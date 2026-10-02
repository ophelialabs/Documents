# DNS Server Challenge

This document describes how to run a DNS server and how to implement the small
authoritative DNS server used by this challenge. The challenge server listens on
UDP port `2053`, rather than the normal DNS port `53`, so that it can be run by a
non-root user.

## 1. Install a DNS server for local testing

You only need one of the following options. Do not run multiple DNS servers on
the same port.

### BIND

On Fedora, RHEL, or CentOS:

```sh
sudo dnf update
sudo dnf install bind bind-utils
```

On Debian or Ubuntu:

```sh
sudo apt update
sudo apt install bind9 dnsutils
```

The main configuration is usually `/etc/named.conf` on Fedora/RHEL and
`/etc/bind/named.conf` on Debian/Ubuntu. The options file is commonly named
`named.conf.options` on Debian/Ubuntu.

Configure forwarders only if this server should resolve names it is not
authoritative for. For example:

```conf
options {
	 directory "/var/cache/bind";
	 recursion yes;
	 allow-query { any; };

	 forwarders {
		  1.1.1.1;
		  8.8.8.8;
	 };
};
```

Create a zone declaration for an authoritative domain, then create its zone
file with the required records. Validate before restarting:

```sh
sudo named-checkconf
sudo named-checkzone example.test /etc/bind/db.example.test
sudo systemctl restart bind9       # Debian/Ubuntu
# or: sudo systemctl restart named  # Fedora/RHEL
```

### Technitium DNS Server

1. Download and install Technitium DNS Server for your operating system.
2. Open the web console shown by the installer.
3. Change the default administrator password immediately.
4. Add a primary zone for your domain.
5. Add the required `A`, `AAAA`, `MX`, `CNAME`, or other records.
6. Configure upstream forwarders in the DNS settings if recursive lookups are
	required.
7. Verify the zone with `dig` before using it from an application.

### Windows Server DNS

1. Open **Server Manager** and choose **Add roles and features**.
2. Install the **DNS Server** role.
3. Open **Tools > DNS** to launch DNS Manager.
4. Create a primary forward lookup zone.
5. Add the required records and configure forwarders under the server's
	**Properties > Forwarders** tab.
6. Confirm that the Windows Firewall allows DNS traffic on UDP/TCP port `53`.

## 2. Verify a DNS service

Use `dig` to send a query. Specify `@127.0.0.1` to select the local server and
include the port when testing a non-standard listener:

```sh
dig @127.0.0.1 -p 2053 example.test A
dig @127.0.0.1 -p 2053 example.test MX
```

Useful checks:

```sh
ss -lun | grep 2053
dig +noall +answer @127.0.0.1 -p 2053 example.test A
```

The challenge implementation should return a response even when it does not
know the requested name. It should preserve the request ID and question, set
the response bit, and use an appropriate response code such as `NXDOMAIN` for
an unknown name.

## 3. Implement the UDP listener

Create a UDP socket bound to `0.0.0.0:2053` (or `127.0.0.1:2053` for local-only
testing). The basic loop is:

```text
socket = UDP socket(AF_INET)
bind(socket, 0.0.0.0:2053)

while true:
	 request, client = receive_datagram(socket)
	 response = build_dns_response(request)
	 send_datagram(socket, response, client)
```

Use a receive buffer large enough for a DNS datagram, validate the packet
length before reading fields, and handle malformed packets without crashing
the process. DNS uses network byte order, which is big-endian.

## 4. DNS message layout

Every DNS message contains five sections, in this order:

1. Header
2. Question
3. Answer
4. Authority
5. Additional

The header is always 12 bytes. Multi-byte integers are unsigned and encoded in
big-endian order. A response normally copies the Question section from the
request and appends records to the other sections.

### Header fields

| Field | Size | Description | Typical response value |
| --- | ---: | --- | ---: |
| ID | 16 bits | Identifier copied from the query | Same as request |
| QR | 1 bit | `0` query, `1` response | `1` |
| OPCODE | 4 bits | Operation type; standard query is `0` | Copy request, normally `0` |
| AA | 1 bit | Server is authoritative for the answer | `1` for an authoritative answer |
| TC | 1 bit | Message was truncated | `0` unless truncating |
| RD | 1 bit | Recursion desired by the client | Copy request |
| RA | 1 bit | Recursion is available | `0` if unsupported |
| Z | 3 bits | Reserved; must be zero | `0` |
| RCODE | 4 bits | Result code | `0` for success, `3` for `NXDOMAIN` |
| QDCOUNT | 16 bits | Number of question entries | Copy request |
| ANCOUNT | 16 bits | Number of answer records | Number returned |
| NSCOUNT | 16 bits | Number of authority records | Number returned |
| ARCOUNT | 16 bits | Number of additional records | Number returned |

The flags occupy two bytes. Build them with bit operations rather than writing
each flag as a separate byte:

```text
flags = (QR << 15) | (OPCODE << 11) | (AA << 10) |
		  (TC << 9) | (RD << 8) | (RA << 7) | RCODE
```

`Z` occupies bits 6 through 4 and should remain zero. The expression above
also leaves those bits clear.

## 5. Encode and decode domain names

DNS names are not stored as ordinary null-terminated strings. Each label is
preceded by its length and the name ends with a zero byte. For example,
`www.example.com` is encoded as:

```text
03 www 07 example 03 com 00
```

When encoding:

- remove one optional trailing dot;
- encode each label using its byte length;
- reject labels longer than 63 bytes;
- reject a complete name longer than 253 bytes;
- finish with `0x00`.

When decoding, stop at the zero terminator and return both the decoded name and
the offset immediately after it. Later, support compression pointers if the
server must parse general DNS responses: a pointer has the two high bits set
and the remaining 14 bits are an offset into the message. Follow pointers with
a loop limit so malformed packets cannot cause an infinite loop.

## 6. Question section

Each question contains:

| Field | Size |
| --- | ---: |
| QNAME | Variable |
| QTYPE | 16 bits |
| QCLASS | 16 bits |

For the common Internet query, `QCLASS` is `1` (`IN`). Important query types
include `A` (`1`), `NS` (`2`), `CNAME` (`5`), `SOA` (`6`), `MX` (`15`), and
`AAAA` (`28`). A minimal challenge implementation can start with one question
and the `A` record type, then add other types deliberately.

## 7. Resource records

Every answer, authority, or additional record has this structure:

| Field | Size |
| --- | ---: |
| NAME | Variable or compression pointer |
| TYPE | 16 bits |
| CLASS | 16 bits |
| TTL | 32 bits |
| RDLENGTH | 16 bits |
| RDATA | `RDLENGTH` bytes |

For an `A` record, `RDATA` is exactly four IPv4 bytes. For an `AAAA` record it
is 16 IPv6 bytes. `CNAME` and `NS` RDATA contain an encoded domain name. `MX`
RDATA contains a 16-bit preference followed by an encoded exchange name.

Set `ANCOUNT` to the number of records actually written. Do not claim records
in the header that are missing from the payload. A response that exceeds the
UDP limit must either set `TC` and truncate at a record boundary or use a
larger transport such as TCP; never cut an RDATA field in half.

## 8. Response algorithm

For each request:

1. Check that at least 12 bytes are present.
2. Parse the header and reject unsupported opcodes or classes cleanly.
3. Parse the question and retain its exact wire representation when possible.
4. Determine whether the requested name and type exist in the local zone.
5. Copy the request ID, `OPCODE`, `RD`, and question into the response.
6. Set `QR=1`, `RA=0` unless recursion is implemented, and `AA=1` for local
	authoritative data.
7. Add matching records to the Answer section.
8. Use `RCODE=0` for a successful answer, `RCODE=3` (`NXDOMAIN`) for an
	unknown name, or `RCODE=4` (`NOTIMP`) for an unsupported operation.
9. Write accurate section counts and send the datagram to the requesting
	client.

For a successful `A` response, the packet should therefore contain the 12-byte
header, the original question, and one `A` resource record. The response ID
must exactly match the query ID.

## 9. Test checklist

Test the smallest useful cases first:

- one `A` query returns the expected IPv4 address;
- the response ID matches the request ID;
- `QR=1`, `AA` is correct, and `RCODE=0` for a known record;
- an unknown name returns `NXDOMAIN` and no answer records;
- an unsupported type does not crash the server;
- multiple labels and a trailing-dot name decode correctly;
- malformed or truncated input is ignored or returned as a format error;
- the process continues serving requests after a bad datagram;
- `dig`, a second client, and repeated queries all work;
- packets larger than the supported UDP size are handled consistently.

Inspect raw packets when debugging serialization:

```sh
dig +qr +noedns @127.0.0.1 -p 2053 example.test A
sudo tcpdump -ni lo udp port 2053 -X
```

The most common implementation errors are using little-endian integers,
forgetting the terminating zero in `QNAME`, calculating counts before adding
records, and rebuilding the response ID instead of copying it from the query.
