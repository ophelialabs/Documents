# Enterprise Security Outline

Comprehensive reference for enterprise security architecture, tools, services, and best practices.

## Table of Contents

- [Security Governance & Frameworks](#security-governance--frameworks)
- [Network Security](#network-security)
- [Identity & Access Management](#identity--access-management)
- [Threat Detection & Incident Response](#threat-detection--incident-response)
- [Vulnerability Assessment](#vulnerability-assessment)
- [Data Protection](#data-protection)
- [Security Orchestration & Automation](#security-orchestration--automation)
- [Penetration Testing & Assessment](#penetration-testing--assessment)
- [Security Training & Resources](#security-training--resources)

---

## Security Governance & Frameworks

**Policy & Compliance Standards**

| Framework | Purpose | Link |
|-----------|---------|------|
| Cloud Security Alliance | Cloud security standards | [CNCF Security & Compliance](https://landscape.cncf.io/#provisioning--security-compliance) |
| Zero Trust Architecture | Identity-first security model | [Open Policy Agent (OPA)](https://www.openpolicyagent.org) |
| Army Cyber Center of Excellence | Government security guidance | [CCoE](https://cybercoe.army.mil) |

**Enterprise Security Services**

- [Infosys Cyber Security Services](https://www.infosys.com/services/cyber-security.html) - Managed security operations
- [SASE Architecture](https://www.netskope.com) - Secure Access Service Edge for distributed environments
- [Huntress Threat Intelligence](https://www.huntress.com) - Managed threat hunting

---

## Network Security

### Reconnaissance & Discovery

| Tool | Purpose | Use Case |
|------|---------|----------|
| [nmap](https://nmap.org) | Network scanning & port mapping | Asset discovery, network mapping |
| [Wireshark](https://www.wireshark.org) | Packet analysis & protocol inspection | Network troubleshooting, forensics |

### Network Monitoring & Analysis

| Tool | Purpose | Use Case |
|------|---------|----------|
| [tcpdump](https://www.tcpdump.org) | Packet capture & analysis | Network traffic monitoring |
| [Snort](https://www.snort.org) | Intrusion detection system (IDS) | Real-time threat detection |
| [Palo Alto Panorama](https://docs.paloaltonetworks.com) | Centralized firewall management | Enterprise network security |

### Wireless Security

| Tool | Purpose | Use Case |
|------|---------|----------|
| [aircrack-ng](https://www.aircrack-ng.org) | Wireless network auditing | WiFi security assessment |
| [wifite](https://github.com/derv82/wifite2) | Automated wireless penetration testing | WiFi vulnerability testing |
| [reaver](https://github.com/t6x/reaver-wps) | WPS attack tool | WiFi recovery testing |
| [pixiewps](https://github.com/wiire-a/pixiewps) | Pixie dust attack | WPS vulnerability exploitation |
| [hostapd](https://w1.fi/hostapd/) | Access point emulation | WiFi testing & simulation |

---

## Identity & Access Management

**Core Principles**
- Least privilege access
- Multi-factor authentication enforcement
- Continuous authentication & verification
- Identity federation & SSO

---

## Threat Detection & Incident Response

### Intrusion Detection & Prevention

| Tool | Purpose | Use Case |
|------|---------|----------|
| [Snort](https://www.snort.org) | IDS/IPS with custom rulesets | Real-time threat detection & prevention |
| [Palo Alto Panorama](https://docs.paloaltonetworks.com) | Threat management console | Centralized threat response |

### Attack Detection Tools

| Tool | Purpose | Use Case |
|------|---------|----------|
| [Ettercap](https://www.ettercap-project.org) | MITM attack detection & testing | Network security assessment |
| [mitmproxy](https://mitmproxy.org) | Proxy for traffic inspection | API security testing, threat analysis |
| [dsniff](https://www.monkey.org/~dugsong/dsniff/) | Network sniffing & credential capture detection | Network behavior analysis |
| [arpspoof](https://www.monkey.org/~dugsong/dsniff/) | ARP spoofing tests | Network integrity verification |

---

## Vulnerability Assessment

### Password Security & Credential Testing

| Tool | Purpose | Use Case |
|------|---------|----------|
| [medusa](https://github.com/jmk-foord/medusa) | Credential brute-force testing | Weak credential identification |
| [crunch](https://github.com/shadawck/crunch) | Wordlist generation | Custom password testing |
| [John the Ripper](https://www.openwall.com/john) | Password hash cracking | Credential compromise analysis |
| [Hashcat](https://hashcat.net) | GPU-accelerated password recovery | Large-scale hash analysis |

### Web Application Security

| Tool | Purpose | Use Case |
|------|---------|----------|
| [sqlmap](http://sqlmap.org) | SQL injection detection & exploitation | Database vulnerability assessment |
| [Burp Suite](https://portswigger.net/burp) | Web application security testing | Comprehensive app vulnerability scanning |
| [OWASP ZAP](https://www.zaproxy.org) | Dynamic security scanning | Automated vulnerability detection |
| [Nikto](https://cirt.net/Nikto2) | Web server scanner | Web infrastructure assessment |
| [DirBuster](https://www.zaproxy.org/docs/desktop/addons/directory-scanner/) | Directory enumeration | Hidden resource discovery |

---

## Penetration Testing & Assessment

### Exploitation Frameworks

| Tool | Purpose | Use Case |
|------|---------|----------|
| [Metasploit Framework](https://docs.metasploit.com) | Penetration testing framework | Full-cycle exploitation testing |
| [Exploit-DB](https://www.exploit-db.com) | Public exploit repository | Vulnerability proof-of-concept development |

### Reverse Engineering & Analysis

| Tool | Purpose | Use Case |
|------|---------|----------|
| [Ghidra](https://ghidra-sre.org) | Static binary analysis & decompilation | Malware analysis, vulnerability discovery |
| [Radare2](https://rada.re) | Reverse engineering framework | Binary analysis & manipulation |
| [Binary Ninja](https://binary.ninja) | Interactive disassembler | Malware investigation & binary analysis |
| [GDB](https://www.gnu.org/software/gdb) | GNU debugger | Dynamic binary analysis |
| [checksec](https://github.com/slimm609/checksec.sh) | Binary hardening verification | Security control validation |
| [objdump](https://sourceware.org/binutils/docs/binutils/objdump.html) | Object file inspection | Binary structure analysis |

### Penetration Testing Orchestration

| Tool | Purpose | Use Case |
|------|---------|----------|
| [Kali Linux](https://www.kali.org/get-kali/#kali-platforms) | Complete penetration testing distribution | Comprehensive security assessment platform |

---

## Data Protection

**Core Principles**
- Data classification & inventory
- Encryption at rest & in transit
- Access control & DLP policies
- Secure data destruction

---

## Security Orchestration & Automation

**Best Practices**
- Policy as code (OPA - Open Policy Agent)
- Automated threat response
- Security orchestration & response (SOAR)
- Infrastructure as code security scanning

---

## System Diagnostics & Troubleshooting

### Port & Service Enumeration

```bash
# Check what process is using a specific port
lsof -i :5000 | head -20
```

**Note:** On macOS Monterey and later, port 5000 is reserved by the AirPlay Receiver service.

**Reference:** [Wikipedia - List of TCP and UDP port numbers](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers)

---

## Penetration Testing & Assessment

### Kali Linux Security Tool Metapackages

[Kali Linux Distribution](https://www.kali.org/get-kali/#kali-platforms) provides organized metapackages for security testing:

**Base Installation**
- `kali-linux-headless` - Base system with essential utilities (headless deployment)
- `kali-tools-top10` - 10 most frequently used penetration testing tools

**Specialized Toolsets by Function**

| Category | Metapackage | Purpose |
|----------|-------------|---------|
| Exploitation | `kali-tools-exploitation` | Exploit development & delivery |
| Sniffing & Spoofing | `kali-tools-sniffing-spoofing` | Network traffic capture & analysis |
| Wireless Testing | `kali-tools-wireless` | WiFi assessment & penetration testing |
| Password Testing | `kali-tools-passwords` | Credential compromise & brute-force testing |
| Reverse Engineering | `kali-tools-reverse-engineering` | Binary analysis & malware investigation |
| Web Testing | `kali-tools-web` | Web application vulnerability assessment |

### Recommended Container Setup

For isolated security testing environments, deploy Kali Linux in a container. This example uses Podman with Enterprise Linux (adapt `apt` to `dnf` for your system):

```bash
podman run -d --name kali-sec -p 8080:80 docker.io/kalilinux/kali-rolling /bin/bash -lc \
  "apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
   DEBIAN_FRONTEND=noninteractive apt-get install -y \
   kali-linux-headless \
   kali-tools-top10 \
   kali-tools-exploitation \
   kali-tools-sniffing-spoofing \
   kali-tools-wireless \
   kali-tools-passwords \
   kali-tools-reverse-engineering \
   kali-tools-web && exec bash"
```

### Top 10 Tools Reference Matrix

| Top 10 | Exploitation | Sniffing & Spoofing | Wireless | Passwords | Reverse Engineering | Web |
|--------|--------------|---------------------|----------|-----------|----------------------|-----|
| [nmap](https://nmap.org) | [exploit-db](https://www.exploit-db.com) | [tcpdump](https://www.tcpdump.org) | [reaver](https://github.com/t6x/reaver-wps) | [medusa](https://github.com/jmk-foord/medusa) | [ghidra](https://ghidra-sre.org) | [zaproxy](https://www.zaproxy.org) |
| [metasploit-framework](https://docs.metasploit.com) | shellcode | [ettercap](https://www.ettercap-project.org) | [wifite](https://github.com/derv82/wifite2) | wordlists | [radare2](https://rada.re) | [wpscan](https://wpscan.com) |
| [burpsuite](https://portswigger.net/burp) | [payloadgenerator](https://github.com/Ekultek/Payloadgenerator) | [arpspoof](https://www.monkey.org/~dugsong/dsniff/) | [airgeddon](https://github.com/v1s1t0r1791/airgeddon) | [crunch](https://github.com/shadawck/crunch) | [binary-ninja](https://binary.ninja) | [dirbuster](https://www.zaproxy.org/docs/desktop/addons/directory-scanner/) |
| [john-the-ripper](https://www.openwall.com/john) | | [mitmproxy](https://mitmproxy.org) | [pixiewps](https://github.com/wiire-a/pixiewps) | | [gdb](https://www.gnu.org/software/gdb) | |
| [hashcat](https://hashcat.net) | | [dsniff](https://www.monkey.org/~dugsong/dsniff/) | [hostapd](https://w1.fi/hostapd/) | | [checksec](https://github.com/slimm609/checksec.sh) | |
| [wireshark](https://www.wireshark.org) | | | | | [objdump](https://sourceware.org/binutils/docs/binutils/objdump.html) | |
| [aircrack-ng](https://www.aircrack-ng.org) | | | | | | |
| [sqlmap](http://sqlmap.org) | | | | | | |
| [nikto](https://cirt.net/Nikto2) | | | | | | |
| [hydra](https://github.com/vanhauser-thc/thc-hydra) | | | | | | |

---

## Intrusion Detection Systems (IDS)

### Snort

[Snort Documentation](https://www.snort.org) - Open-source network intrusion prevention system

**Custom Rulesets**
- Signature-based detection
- Real-time traffic analysis
- Protocol anomaly detection
- Application-layer threat detection

**Deployment Scenarios**
- Inline IPS mode - Active threat blocking
- Offline IDS mode - Packet capture analysis
- Hybrid deployments - Centralized log aggregation with Palo Alto Panorama

---

## Enterprise Security Services & Platforms

| Service | Purpose | Use Case |
|---------|---------|----------|
| [Palo Alto Panorama](https://docs.paloaltonetworks.com) | Centralized threat management | Enterprise-wide security orchestration |
| [Huntress](https://www.huntress.com) | Managed threat hunting | Continuous threat detection & response |

---

## Additional Resources

**Learning & Research**
- [Zero Security on YouTube](https://www.youtube.com/zsecurity) - Security tutorials & demonstrations
- [FRIDA Dynamic Instrumentation](https://frida.re/) - Runtime binary analysis & manipulation
- [MITRE ATT&CK](https://attack.mitre.org/) - Adversary tactics & techniques framework
- [CIS Controls](https://www.cisecurity.org/cis-controls/) - Critical security controls

---

## Implementation Best Practices

### Defense in Depth

1. **Perimeter Security** - Firewalls, VPNs, WAF
2. **Network Detection** - IDS/IPS, network segmentation
3. **Endpoint Protection** - EDR, antimalware, host-based firewall
4. **Identity Security** - MFA, SSO, PAM
5. **Data Protection** - Encryption, DLP, classification
6. **Incident Response** - Detection, containment, recovery

### Security Operations Center (SOC)

- 24/7 monitoring and threat detection
- Centralized log management and SIEM
- Incident response procedures
- Threat intelligence integration
- Security metrics and KPIs

### Continuous Assessment

- Vulnerability scanning and remediation
- Penetration testing and red teaming
- Security awareness training
- Configuration management and compliance audits


# Security Tools & Services

Resources for enterprise security, risk management, and threat
intelligence.

[CCoE](https://cybercoe.army.mil) | [Infosys](https://www.infosys.com/services/cyber-security.html) | [OPA](https://www.openpolicyagent.org) | [CNCF Security & Compliance](https://landscape.cncf.io/#provisioning--security-compliance) | [SASE for Dummies](https://www.netskope.com)

[zsecurity](https://www.youtube.com/zsecurity) | [FRIDA](https://frida.re/)

## Kali

[Choose your platform](https://www.kali.org/get-kali/#kali-platforms)

### Container Build

Container images are minimal by design and do not ship with the full desktop environment or security tool meta-packages.

Open terminal (I am using Enterprise Linux so you would switch apt for dnf). apt pkg manager is Ubuntu (Debian)

```bash
podman run -d --name kali-sec -p 8080:80 docker.io/kalilinux/kali-rolling /bin/bash -lc \
  "apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
   DEBIAN_FRONTEND=noninteractive apt-get install -y \
   kali-linux-headless \
   kali-tools-top10 \
   kali-tools-exploitation \
   kali-tools-sniffing-spoofing \
   kali-tools-wireless \
   kali-tools-passwords \
   kali-tools-reverse-engineering \
   kali-tools-web && exec bash"
```

#### Kali Security tool metapackages

`kali-linux-headless` | Base system, essential utilities

| Top 10 | Exploitation | Sniffing & Spoofing | Wireless | Passwords | Reverse Engineering | Web |
|--------|--------------|---------------------|----------|-----------|----------------------|-----|
| [nmap](https://nmap.org) | [exploit-db](https://www.exploit-db.com) | [tcpdump](https://www.tcpdump.org) | [reaver](https://github.com/t6x/reaver-wps) | [medusa](https://github.com/jmk-foord/medusa) | [ghidra](https://ghidra-sre.org) | [zaproxy](https://www.zaproxy.org) |
| [metasploit-framework](https://docs.metasploit.com) | shellcode | [ettercap](https://www.ettercap-project.org) | [wifite](https://github.com/derv82/wifite2) | wordlists | [radare2](https://rada.re) | [wpscan](https://wpscan.com) |
| [burpsuite](https://portswigger.net/burp) | [payloadgenerator](https://github.com/Ekultek/Payloadgenerator) | [arpspoof](https://www.monkey.org/~dugsong/dsniff/) | [airgeddon](https://github.com/v1s1t0r1791/airgeddon) | [crunch](https://github.com/shadawck/crunch) | [binary-ninja](https://binary.ninja) | [dirbuster](https://www.zaproxy.org/docs/desktop/addons/directory-scanner/) |
| [john-the-ripper](https://www.openwall.com/john) | | [mitmproxy](https://mitmproxy.org) | [pixiewps](https://github.com/wiire-a/pixiewps) | | [gdb](https://www.gnu.org/software/gdb) | |
| [hashcat](https://hashcat.net) | | [dsniff](https://www.monkey.org/~dugsong/dsniff/) | [hostapd](https://w1.fi/hostapd/) | | [checksec](https://github.com/slimm609/checksec.sh) | |
| [wireshark](https://www.wireshark.org) | | | | | [objdump](https://sourceware.org/binutils/docs/binutils/objdump.html) | |
| [aircrack-ng](https://www.aircrack-ng.org) | | | | | | |
| [sqlmap](http://sqlmap.org) | | | | | | |
| [nikto](https://cirt.net/Nikto2) | | | | | | |
| [hydra](https://github.com/vanhauser-thc/thc-hydra) | | | | | | |

---

check what's currently using port #

```
lsof -i :5000 | head -20
```

**On macOS Monterey and later, port 5000 is often reserved by the AirPlay Receiver service.**

<wiki:List_of_TCP_and_UDP_port_numbers>

---

## Snort

Custom rulesets

---

| [Palo Alto Panorama](https://docs.paloaltonetworks.com) | [Huntress](https://www.huntress.com)

