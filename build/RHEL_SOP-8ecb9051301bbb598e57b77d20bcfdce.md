# Standard Operating Procedure (SOP)
# RHEL Enterprise Access, Security, and Monitoring

## SOP Number
SOP-ENT-02-LINUX-01

## Effective Date
2026-10-23

## Revision
1.0

## Approval
- System Owner: Enterprise Infrastructure
- Security Lead: Information Security
- Operational Owner: Linux and Endpoint Engineering

## 1. Purpose
This SOP establishes the approved procedure for secure configuration, access authorization, and monitoring of enterprise Linux and virtual desktop environments supporting OWL, WISE, and CENTRALSHARE operations. It applies to administrators, security engineers, and support personnel responsible for endpoint configuration, identity access, and service monitoring.

## 2. Scope
This procedure covers:
- RHEL system baseline review and directory validation
- Derived credential and smart-card setup
- Cloud security and compliance alignment
- AVD/Hypori access onboarding and troubleshooting
- vSphere/VCF API-based infrastructure monitoring

## 3. Roles and Responsibilities
- Linux administrators: configure, validate, and maintain operating system baselines
- Security staff: review compliance posture, access controls, and credential handling
- Endpoint support: manage user onboarding, CAC/TPM, and virtual desktop access
- Operations staff: validate monitoring, telemetry, and health-check workflows

## 4. References
- [RHEL 9 Documentation](https://docs.oracle.com/en/operating-systems/oracle-linux/9/)
- [VCF STIG Documentation](https://techdocs.broadcom.com/us/en/vmware-cis/vcf/stig/9-0/vcf-stig-documentation/docs-tutorials-cloud-foundation-9x-product-vcf-application-audit9-app-audit9-app.html)
- [SAF CLI](https://github.com/mitre/saf/releases)
- [DX NetOps](https://techdocs.broadcom.com/us/en/ca-enterprise-software/it-operations-management/dx-netops/24-3.html)
- [DX Spectrum](https://techdocs.broadcom.com/us/en/ca-enterprise-software/it-operations-management/spectrum/22-2.html)
- [OneClick](https://techdocs.broadcom.com/us/en/ca-enterprise-software/it-operations-management/spectrum/25-4/getting-started/client-applications-overview/oneclick-console.html)
- [Hypori](https://www.hypori.com/)
- [vSphere World Metrics API Guide](https://www.brockpeterson.com/post/pulling-vsphere-world-metrics-from-vcf-operations)

---

## 5. Operational Baseline

### 5.1 Required system directories
Use these directories as the baseline for system review, forensic investigation, and policy alignment.

- `/` — root filesystem
- `/home` — user home directories
- `/tmp` — temporary files
- `/var` — variable data and service state
- `/var/tmp` — persistent temporary storage for system processes
- `/var/log` — system logs
- `/var/log/audit` — audit logs and authentication events
- `/boot` — bootloader and kernel files

### 5.2 Policy and security locations
- `/usr/share/stigs` — STIG content and security baselines
- Security import policies — review and validate local policy imports for compliance enforcement
- STIG references — maintain current documentation from VMware/VCF STIG guidance

---

## 6. Security Standards and Compliance Requirements

### 6.1 Derived credentials and PKI
Purebred, FedRAMP, and FIPS collectively support the enterprise identity model for secure access to government and regulated cloud environments.

- Purebred: provides a secure, derived credential model for mobile devices and PKI-based access without a physical CAC
- FedRAMP: establishes risk and authorization controls for government cloud platforms
- FIPS: defines cryptographic standards and approved security implementations

### 6.2 Required control model
1. Identity trust begins with a verified credential model.
2. Access policies enforce authorization and user authentication.
3. Cryptographic standards provide the protection layer for data and session integrity.
4. Cloud hosting providers must meet the required compliance profile to support sensitive workloads.

### 6.3 Provider ecosystem
- BlackBerry AtHoc
- Microsoft Azure Government
- AWS GovCloud
- Axiad Conductor
- Appian Gov Cloud

> Note: These solutions support enterprise access and compliance patterns, but each environment must be validated against the governing authority and mission requirements.

### 6.4 Secure disposal requirements
Always shred or sanitize drives and motherboards before disposal to prevent credential harvesting and data leakage.

---

## 7. Procedure: Derived Credentials and TPM Smart Card Setup

### 7.1 Purpose
This procedure establishes the approved method for creating and enrolling a virtual smart card and derived credential in supported enterprise Windows environments.

### 7.2 Requirements
- Windows 10 or Windows 11, or a supported Windows Server environment
- TPM enabled in BIOS/UEFI
- `tpmvscmgr.exe` utility available
- A valid enterprise trust process and certificate enrollment workflow
- Smart card provider or enterprise credential service support

### 7.3 Setup procedure
1. Open Command Prompt as Administrator.
2. Run the following command:

```bash
tmpvscmgr.exe create /name testVSC /pin prompt /adminkey random /generate
```

This creates a virtual smart card named `TestVSC`, prompts for a PIN, and generates the backing filesystem.

### 7.4 Certificate enrollment
1. Open `certmgr.msc`.
2. Navigate to Personal.
3. Right-click and select: All Tasks > Request New Certificate.
4. Choose the TPM VSC as the target certificate store.

### 7.5 Alternative method
- Omnissa Horizon Client: Settings > Derived Credentials > Create new VSC

### 7.6 Smart business card (NFC) workflow
Use this for secure digital profile exchange and contact sharing:
1. Select a smart business card provider such as Wave or Popl.
2. Create a profile and register it with the provider.
3. Add your contact details, social media links, and bio.
4. Order or activate an NFC-enabled card or tag.
5. Provide a digital alternative using QR code or Apple/Google Wallet integration.

### 7.7 Completion criteria
- Windows 10/11 or supported Windows Server with TPM enabled
- `tpmvscmgr.exe` available and configured
- Smart business card provider or digital identity service
- NFC-capable smartphone for tap-transfer scenarios
- Customized digital profile for contact and identity sharing

---

## 8. Procedure: Cloud Security and Access Controls

### 8.1 Core controls
Cloud security should combine identity, compliance, and cryptographic controls. The core model is:
- Verified user identity
- Controlled access boundaries
- Federated governance and policy enforcement
- Secure key and certificate management

### 8.2 Common reference model
- Purebred supports derived identity for secure access
- FedRAMP governs cloud service authorization for U.S. federal workloads
- FIPS ensures approved encryption and cryptographic implementation

### 8.3 Required checks
- Validate identity federation and access controls
- Confirm device trust and certificate issuance flow
- Review cloud service authorization status
- Enforce least privilege for user and service accounts
- Monitor sensitive access paths and admin activity

---

## 9. Procedure: Hypori and Azure Virtual Desktop (AVD) Access

### 9.1 Purpose
This procedure defines approved onboarding and login steps for controlled remote access through Hypori and Azure Virtual Desktop.

### 9.2 Quick facts
- Enterprise AVD is a Windows 11 virtual machine used with Microsoft 365 credentials
- Remote Desktop clients support CAC login and S/MIME encryption
- Best experience is typically on Windows or macOS using the remote desktop client
- Available on NIPR and commercial networks
- Dual persona scenarios may require separate workspaces and onboarding events

### 9.3 Setup steps
1. Log in from a NIPR computer or a personal computer with CAC capability.
2. Start onboarding at the provided AVD setup portal and confirm the acknowledgment.
3. Receive the onboarding email from the AVD team.
4. Choose the preferred access option:
   - Option A: Azure Virtual Desktop application
   - Option B: Browser-based access

### 9.4 Option A: Azure Virtual Desktop application
1. Install the Microsoft Remote Desktop client.
2. Open the app and select Add Workspace.
3. Enter the workspace URL: `rdweb.wvd.azure.us`.
4. Log in using the A365/M365 account.
5. Select the proper CAC certificate and enter the PIN.
6. Choose the closest environment (East or West).
7. Accept the prompts and complete setup.

### 9.5 Option B: Browser access
1. Open the browser-based access portal.
2. Log in with the A365/M365 account.
3. Select the correct CAC certificate and enter the PIN.
4. Choose the nearest server region.

### 9.6 Persona and onboarding considerations
- Separate personas may require independent virtual workspaces.
- Each persona may need its own onboarding and certificate enrollment flow.
- Users must complete the onboarding process separately when using multiple personas.

---

## 10. Procedure: vSphere/VCF API Monitoring

### 10.1 Purpose
This procedure defines the approved method for querying vSphere World and related infrastructure metrics through the VCF Operations API.

### 10.2 Authentication
The API endpoint is typically exposed as:

```text
https://<operations_fqdn_or_ip>/suite-api
```

#### Local authentication
1. Open the Operations API home page.
2. Select Authorize in the upper-right corner.
3. Use the API token acquisition call: `POST /suite-api/api/auth/token/acquire`.
4. Store the returned bearer token for later requests.

#### Bearer token usage
Use the value in the Authorization header for subsequent requests.

#### Basic authentication
Basic auth may be disabled by default. If required, enable it in configuration and restart the API service as needed.

```bash
service api restart
```

> Repeat the restart on all nodes in the cluster if required by the environment.

### 10.3 Discover the vSphere World resource
Request the available resources and filter by `ResourceKind = vSphere World`.

```http
GET /api/resources
```

Use the matching resource identifier returned from the response. This is the key object used to pull metrics.

### 10.4 Retrieve stat keys
Determine which metrics are available for the selected resource.

```http
GET /api/resources/statkeys?resourceId=<resource_id>
```

Common metric keys include:
- `summary|total_number_clusters`
- `summary|total_number_hosts`
- `summary|total_number_vms`

### 10.5 Retrieve latest metric values
Once the stat keys are known, request the current values.

```http
GET /api/resources/stats/latest?resourceId=<resource_id>&statKeys=summary|total_number_clusters,summary|total_number_hosts,summary|total_number_vms
```

This returns the current values for clusters, ESXi hosts, and VMs. The results can then be compared against the UI for validation.

### 10.6 Operational use
This method can be reused for other objects and metrics in the platform. It is a strong approach for gathering operational telemetry without relying only on GUI dashboards.

---

## 11. Required Readiness Checklist

### Before deployment or access rollout
- Confirm OS and security baseline compliance
- Validate TPM, certificate enrollment, and smart-card support
- Review user identity model and derived credential workflow
- Verify AVD or remote access prerequisites
- Confirm cloud and compliance requirements for the environment

### During deployment
- Validate core directory structures and access controls
- Confirm logging and audit configuration
- Verify user provisioning and subscription status
- Validate endpoint certificate trust and PIN access flow

### After deployment
- Test remote access and authentication flow
- Validate API-based infrastructure metric collection
- Record configuration baselines and access decisions
- Review logs for anomalies or misconfigurations

---

## 12. Exceptions and Escalation
Any exception to this SOP must be documented, approved by the relevant security or infrastructure owner, and tracked as a deviation. Escalate to the system owner or security lead when:
- a required control cannot be validated
- a compliance baseline does not match current configuration
- user access cannot be completed without bypassing policy
- monitoring or telemetry does not align with expected infrastructure state

---

## 13. Final Operational Guidance
Enterprise Linux, identity federation, and virtual desktop access rely on disciplined configuration, strong authentication, and continual validation. Use this SOP as the approved operational reference for secure setup, policy alignment, and infrastructure monitoring, and always verify environment-specific requirements before production rollout.

---

## 14. Quick Reference
- Linux baseline: `/`, `/home`, `/tmp`, `/var`, `/var/log`, `/var/log/audit`, `/boot`
- Security policy: `/usr/share/stigs`
- Smart card workflow: `tpmvscmgr.exe` + certificate enrollment
- Access model: AVD, CAC, TPM-backed identity
- Monitoring model: Operations API + vSphere World metric queries

This SOP should be treated as a working enterprise operational reference, not a substitute for official vendor documentation or environment-specific approval workflows.
