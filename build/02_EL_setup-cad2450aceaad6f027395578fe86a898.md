---
title:
---

## Easiest Startup
Create a VM using OL 9+, during setup process, choose server option with GUI, create admin username and password. Partition hard drive with the [directories](03_Enterprise/technology-and-infrastructure/Foundations/02_linux/setup-1/README.md) listed. Then import Security Policies (do not choose draft). Click on finish setup. 

## Before We Begin

- Tools and features do not need to be installed on the same server for communication.
- **Personal Preferences**:
    - Organization is key!
    - Use specific bookmarks for certain browsers.
    - Naming conventions. Along with organization, good file naming practices.
    - Set up shared directories to avoid redundant file paths (e.g., in VS Code) and downloads (e.g., ISOs or other files).
    
If any free trials are available for any cloud providers, using this guide first will hopefully be extremely helpful by assisting in set up so there can be more focus on a development environment and integrations in a multi cloud environment

Windows Server (6mo eval) + Azure (30day $200cred) \
Google Cloud Platform (3mo $300cred) \
Amazon Web Services (VPS 3mo , EC2 12mo , certain services 12mo) \
[Sharepoint](https://www.microsoft.com/en-us/microsoft-365/SharePoint/compare-SharePoint-plans) MS 365 Business Standard (30day)

---

## Enterprise Linux
[Docs](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/10).

Run the setup script as a regular user with `sudo` access; do not invoke it with `sudo`, because it expects to run in the user's session and uses `sudo` only for privileged operations.

```bash
chmod +x scripts/linux_setup.sh
./scripts/linux_setup.sh
```

### Preflight

Before showing the area menu, the script verifies EL 9/10, architecture (`x86_64`, `aarch64`, or `s390x`), sudo availability, and FIPS status. DISA STIG confirmation is advisory. Set `REQUIRE_FIPS=1` to stop if kernel FIPS mode is not reported enabled. The script does not certify compliance.

### 1. Select Setup Areas

At startup, choose one or more areas by entering comma-separated numbers, or enter `all` or `q`:

1. Developer tools
2. Database / Oracle
3. Network
4. Host security
5. Cloud CLIs
6. IBM Z / COBOL
7. Virtualization
8. VS Code / Insiders
9. Local services
10. All areas

The selected areas run in the order entered. For non-interactive use, set `SETUP_AREAS`, for example:

```bash
SETUP_AREAS=dev,db,net,sec ./scripts/linux_setup.sh
```

After selection, the installer installs base utilities, runs the chosen areas in order, and finishes with browser guidance. On a graphical system it opens account/setup pages and any responding local service pages; on a headless system it writes bookmark HTML files in the user's home directory.

### 2. Developer Tools

Installs compiler/build tools, Git, Node.js/npm, Java 21, and Go. VS Code/Insiders is a separate area. After a successful IDE install, the script can install GitHub CLI and offer account signup or browser-based authentication. Existing-account authentication uses SSH as the Git transport; GitHub account passwords are not requested.

### 3. Database / Oracle

The Oracle submenu can pull the GoldenGate Studio Free container image, offer Oracle Linux ASMLIB prerequisites, or show Oracle Database and Database@Google Cloud references. It does not start GoldenGate, configure ASM disks, change kernel settings, install Oracle Database, or provision cloud resources.

 - [DB Browser](https://sqlitebrowser.org/) | [SQL Server](https://www.microsoft.com/en-us/sql-server)/[WinServer](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2025)

#### ASMLIB
[1](https://docs.oracle.com/en/operating-systems/oracle-linux/asmlib/asmlib-Preface.html#preface)

- Driver Requirements: OL9 + RHCK: No driver required, but `io_uring` must be enabled.

- Enable `io_uring`: Add the following line to `/etc/sysctl.conf`:
```bash
kernel.io_uring_disabled = 0
```
- Apply the changes:
```bash
$ sudo sysctl -p
$ sudo dnf update -y
```
- **ULN Recommended**: Keep the system updated by subscribing to the [Oracle Linux Network (ULN)](https://linux.oracle.com).
- **Steps to Subscribe**:
    1. Sign in or register [here](https://linux.oracle.com).
    2. Navigate to the **Systems** tab > **Registered Systems** > Select the system link.
    3. On the **System Details** page, go to **Manage Subscriptions**.
    4. On the **System Summary** page:
         - Select **ASMLIB** and **Oracle Linux Addons** from the available channels.
         - Click the right arrow to subscribe.
         - Save the subscriptions.

##### Manual Patches and Updates
If not subscribed to ULN, download packages manually:
- [ASMLIB v8](https://www.oracle.com/linux/downloads/linux-asmlib-v8-downloads.html)
- [ASMLIB v9](https://www.oracle.com/linux/downloads/linux-asmlib-v9-downloads.html)

##### Installation Commands
Install ASMLIB support:
```bash
$ sudo dnf install oracleasm-support oracleasmlib
```

#### GoldenGate Free
<img src="src/assets/gg1.png">
 
[1](https://www.oracle.com/integration/goldengate/), [2](https://docs.oracle.com/en/middleware/goldengate/studio-free/23/uggsf/get-started.html#GUID-42B5358A-A84E-45D2-90CC-D55A474B3678) | [GG 21c YT](https://www.youtube.com/watch?v=aekcNiAYC7k&list=PLbqmhpwYrlZJctD-SEORxzDtjc-apJuL5&index=3)
```bash
$ podman login container-registry.oracle.com
$ podman pull container-registry.oracle.com/goldengate/goldengate-studio-free:latest
$ docker run -p 80:80 -p 443:443 container-registry.oracle.com/goldengate/goldengate-studio-free:latest
```

#### Oracle DB 23ai & 23c
23ai [1](https://docs.oracle.com/en/database/oracle/oracle-database/23/install.html), 23c [1](https://docs.oracle.com/en/database/oracle/oracle-database/23/install-and-upgrade/index.html)

#### Oracle Exadata
gcloud auth login
gcloud config set project [PROJECT_ID]
gcloud compute instances create [INSTANCE_NAME] --zone=[ZONE] --machine-type=[MACHINE_TYPE] --image-project=oracle-cloud-exadata --image-family=exadata-infrastructure --boot-disk-size=500GB --boot-disk-type=pd-ssd --metadata=oracle-cloud-exadata-infrastructure=true

- [Oracle Database@Google Cloud](https://docs.oracle.com/en-us/iaas/Content/database-at-gcp-exadata/ogexa-provisioning-exadata-infrastructure.html): From Google Cloud console, open the Oracle Database@Google Cloud application.

#### HorizonDB
[1](https://www.infoq.com/news/2025/12/azure-horizondb-postgresql/)

### 4. Network

The network menu offers VPN, HA clustering, or HAProxy/Keepalived packages. VPN has its own WireGuard or Libreswan submenu. Configuration and service exposure are guarded by prompts. For Production purposes, [Libreswan](https://libreswan.org) is the recommended option. Red Hat classifies [WireGuard](https://www.wireguard.com) as an unsupported Technology Preview; check support for the specific EL distribution before using it. [1](https://docs.oracle.com/en/operating-systems/oracle-linux/9/network/)

#### Management Tools
[Tailscale](https://tailscale.com/) | [pfSense](https://www.pfsense.org/) | [OPNsense](https://www.opnsense.org/) | [OpenWRT](https://www.openwrt.org/)

Install and use `NetworkManager-tui` for text-based network configuration:
```bash
sudo dnf install -y NetworkManager-tui
sudo nmtui
```

Install and use `nm-connection-editor` for graphical network configuration:
```bash
sudo dnf install -y nm-connection-editor
sudo nm-connection-editor
```

#### [High Availability Clustering]()
Install Required Packages. Enable necessary repositories and install HA packages:
```bash
$ sudo dnf config-manager --enable ol9_appstream ol9_baseos_latest ol9_addons
$ sudo dnf install pcs pacemaker resource-agents fence-agents-all
```

##### Configure Firewall
If `firewalld` is running, add the HA service to each node. A script can be used to auto-check `firewalld` status before proceeding.

Required Ports:
- **TCP Ports**:
    - `2224` (pcs daemon)
    - `3121` (Pacemaker Remote nodes)
    - `21064` (DLM resources)
- **UDP Ports**:
    - `5405` (Corosync clustering)
    - `5404` (Corosync multicast, if configured)

Add the HA service to the firewall:
```bash
$ sudo firewall-cmd --permanent --add-service=high-availability
$ sudo firewall-cmd --add-service=high-availability
```

##### Enable and Start Services
Set a password for the `hacluster` user and enable the `pcsd` service:
```bash
$ sudo passwd hacluster
$ sudo systemctl enable --now pcsd.service
```

#### [Load Balancing](https://docs.oracle.com/en/operating-systems/oracle-linux/9/balancing/index.html#documentation-license)

##### High Availability (HA) Load Balancing
HA Load Balancing can be achieved using tools like:
- **HAProxy**: Round Robin
- **Keepalived**: NAT
- **NGINX**: Round Robin (RR), Weighted Round Robin (WRR), Least Connections Load Balancing (LCLB)

##### Installation
On each front-end server, install the required packages:
```bash
sudo dnf install -y haproxy keepalived
```

##### Configuration
Edit the configuration files for each server:
- `/etc/haproxy/haproxy.cfg`
- `/etc/keepalived/keepalived.conf`

##### Enable HAProxy to Handle Port 80
Allow traffic on port 80 using `firewall-cmd`:
```bash
sudo firewall-cmd --zone=zone --add-port=80/tcp
# Or for a permanent rule:
sudo firewall-cmd --permanent --zone=zone --add-port=80/tcp
```

##### Start and Enable HAProxy
Enable and start the HAProxy service:
```bash
sudo systemctl enable --now haproxy
```

##### Enable IP Forwarding
Modify `/etc/sysctl.conf` to enable IP forwarding:
```bash
net.ipv4.ip_forward = 1
```

Verify that IP forwarding is enabled:
```bash
sudo sysctl -p
# Or
net.ipv4.ip_forward = 1
```

### 5. Host Security

Optional tools include audit logging (`auditd`), file integrity monitoring (AIDE), report-only OpenSCAP assessment, and smart-card reader/token utilities with provisioning guidance. AIDE baseline creation and OpenSCAP scanning require confirmation. Smart-card installation does not initialize cards, issue certificates, or change PAM/SSSD login policy.

### 6. Cloud CLIs

Offers Azure CLI, AWS CLI v2, Google Cloud CLI, IBM Cloud CLI, and Oracle Cloud CLI. Each is optional. IBM Cloud plugin installation is separately prompted because installing every plugin can be a large download. Account login and cloud provisioning remain separate user tasks.

### 7. IBM Z / COBOL

Offers Zowe CLI with CICS, Db2, MQ, and z/OS FTP plugins, IBM Z Open Editor for installed VS Code builds, or LinuxONE documentation. Remote z/OS use requires an authorized, reachable z/OSMF or RSE API endpoint and user-created configuration.

### 8. Virtualization

Installs KVM/libvirt and Cockpit machine-management packages and attempts to enable the relevant libvirt sockets. Hardware availability and host validation determine whether virtualization can operate.

### 9. VS Code / Insiders

Adds Microsoft's RPM repository and offers VS Code Stable, Insiders, both, or skip. A skip does not stop the rest of the selected setup areas.

### 10. Local Services

The service submenu offers Cockpit, Grafana, Jenkins, Portainer, and the Strelka stack (which includes Jaeger and Strelka UI). It only opens service URLs that respond locally. Portainer is bound to localhost. Strelka's quickstart uses default credentials; change them before any broader exposure.

### Final Step: Browser Guidance

The script opens the account setup pages and responsive local service pages in separate browser windows when a desktop session and supported browser are available. Otherwise, it writes `Account-Setup-bookmarks.html` and, when local services respond, `Local-Services-bookmarks.html` under the user's home directory.

### Remaining Work

- `all` selects all top-level areas, but nested menus still use their safe skip/back defaults. It does not mean every optional component or cloud account is fully configured.
- Database support is currently guidance and image pulling, not a complete database installation or deployment workflow.
- Network, smart-card, cloud, and service setups still require environment-specific configuration and operator review.
- Review package names, repository support, and service behavior for the exact EL vendor, release, architecture, and organizational policy before production use.
