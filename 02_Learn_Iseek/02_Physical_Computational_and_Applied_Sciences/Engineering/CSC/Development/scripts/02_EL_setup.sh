#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_NAME=${0##*/}
EL_MAJOR=
ARCH=$(uname -m)
INSTALL_LOG=${INSTALL_LOG:-"$HOME/linux-setup-$(date +%Y%m%d-%H%M%S).log"}

log() { printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*" | tee -a "$INSTALL_LOG"; }
warn() { printf 'WARNING: %s\n' "$*" >&2; }
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

as_root() {
  if [[ $EUID -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

ask_yes_no() {
  local prompt=$1 default=${2:-N} answer
  if [[ ! -t 0 ]]; then
    return 1
  fi
  if [[ $default == Y ]]; then
    read -r -p "$prompt [Y/n] " answer
    answer=${answer:-Y}
  else
    read -r -p "$prompt [y/N] " answer
    answer=${answer:-N}
  fi
  [[ $answer =~ ^([Yy]|[Yy][Ee][Ss])$ ]]
}

install_packages() {
  log "Installing packages: $*"
  as_root dnf install -y "$@"
}

check_platform() {
  [[ -r /etc/os-release ]] || fail "Cannot identify this operating system."
  . /etc/os-release
  local version_id=${VERSION_ID:-}
  EL_MAJOR=${version_id%%.*}

  [[ $EL_MAJOR == 9 || $EL_MAJOR == 10 ]] || fail "This script supports EL9 and EL10; detected ${PRETTY_NAME:-unknown}."
  [[ $ARCH == x86_64 || $ARCH == aarch64 || $ARCH == s390x ]] || fail "Unsupported architecture: $ARCH."
  [[ ${ID_LIKE:-} == *rhel* || ${ID:-} == oracle* || ${ID:-} == rhel || ${ID:-} == rocky || ${ID:-} == almalinux ]] || \
    warn "${PRETTY_NAME:-This operating system} is not a recognized RHEL derivative; package names may differ."

  if [[ $EUID -eq 0 ]]; then
    fail "Run this script as a regular user with sudo access, not with sudo. The browser setup must run in your desktop session."
  fi
  command -v sudo >/dev/null 2>&1 || fail "sudo is required."
  sudo -v || fail "Could not obtain sudo authorization."
  log "Platform: ${PRETTY_NAME:-EL$EL_MAJOR}, architecture: $ARCH"
}

check_compliance_status() {
  local fips_state=unknown
  if [[ -r /proc/sys/crypto/fips_enabled ]]; then
    if [[ $(< /proc/sys/crypto/fips_enabled) == 1 ]]; then
      fips_state=enabled
    else
      fips_state=disabled
    fi
  fi

  log "Kernel FIPS mode: $fips_state"
  if command -v fips-mode-setup >/dev/null 2>&1; then
    fips-mode-setup --check 2>&1 | tee -a "$INSTALL_LOG" || warn "FIPS mode check reported a problem."
  else
    warn "fips-mode-setup is unavailable; kernel FIPS status is the only check performed."
  fi

  if [[ ${REQUIRE_FIPS:-0} == 1 && $fips_state != enabled ]]; then
    fail "REQUIRE_FIPS=1 but kernel FIPS mode is not confirmed enabled. Enable and validate FIPS mode using your approved process before continuing."
  fi

  if [[ ${DISA_STIG_BASELINE_CONFIRMED:-0} == 1 ]]; then
    log "DISA STIG baseline: operator-reported as applied; this script does not certify compliance."
  else
    log "DISA STIG baseline: not confirmed (advisory only; continuing with setup)."
  fi
}

install_best_practices() {
  install_packages dnf-update dnf-upgrade dnf-automatic
}

install_base() {
  install_packages ca-certificates curl wget git jq unzip tar gzip gnupg2 dnf-plugins-core
}

install_developer_tools() {
  install_packages gcc gcc-c++ make cmake git nodejs npm java-21-openjdk java-21-openjdk-devel golang
  log "Developer tools installed. Node: $(node --version 2>/dev/null || echo unavailable); npm: $(npm --version 2>/dev/null || echo unavailable)."
}

install_virtualization() {
  install_packages cockpit-machines qemu-kvm libvirt virt-install virt-viewer
  for driver in qemu network nodedev nwfilter secret storage interface; do
    as_root systemctl enable --now "virt${driver}d.socket" 2>/dev/null || true
  done
  as_root systemctl enable --now libvirtd.socket 2>/dev/null || true
  command -v virt-host-validate >/dev/null 2>&1 && virt-host-validate || true
}

database_setup_menu() {
  local choice
  echo "Database and Oracle infrastructure options:"
  echo "1) GoldenGate Studio Free container image"
  echo "2) Oracle ASM / ASMLIB host prerequisites"
  echo "3) Oracle Database installation and Database@Google Cloud guidance"
  echo "4) Back to setup selection"
  read -r -p "Choose a database option [4]: " choice || choice=4

  case ${choice:-4} in
    1)
      if ! command -v podman >/dev/null 2>&1; then
        install_packages podman
      fi
      echo "GoldenGate Studio Free registry access may require Oracle account entitlement and acceptance of registry terms."
      if ask_yes_no "Log in to container-registry.oracle.com and pull GoldenGate Studio Free" N; then
        podman login container-registry.oracle.com
        podman pull container-registry.oracle.com/goldengate/goldengate-studio-free:latest
        log "Image pulled. Review Oracle's current container documentation and image port/storage requirements before starting it."
        log "The legacy el9_db.sh example maps privileged ports 80/443; this menu intentionally does not start the container or expose ports."
      fi
      ;;
    2)
      if [[ ${ID:-} != ol && ${ID:-} != *oracle* ]]; then
        warn "ASMLIB packages and kernel guidance here target Oracle Linux; detected ${PRETTY_NAME:-unknown}. No packages installed."
      else
        log "Detected Oracle Linux ${VERSION_ID:-$EL_MAJOR}; kernel: $(uname -r)."
        echo "Oracle ASM libraries are only needed when configuring Oracle ASM storage."
        echo "Kernel-specific packages differ between UEK and RHCK; do not apply a generic driver recipe."
        if ask_yes_no "Install Oracle ASMLIB support packages for this Oracle Linux host" N; then
          install_packages oracleasm-support oracleasmlib
          log "ASMLIB support packages installed. Verify the current Oracle Linux/kernel-specific setup guide before configuring or scanning disks."
        fi
        if ask_yes_no "Show Oracle Linux ASMLIB and io_uring references" Y; then
          printf '%s\n' \
            "Oracle Linux 9 Storage Administration: https://docs.oracle.com/en/operating-systems/oracle-linux/9/stordev/" \
            "Oracle ASMLIB: https://www.oracle.com/linux/technologies/oracle-linux-asmlib.html"
          log "No sysctl or kernel settings were changed."
        fi
      fi
      ;;
    3)
      printf '%s\n' \
        "Oracle Database 23ai installation: https://docs.oracle.com/en/database/oracle/oracle-database/23/install/" \
        "Oracle Database@Google Cloud provisioning: https://docs.oracle.com/en-us/iaas/Content/database-at-gcp-exadata/ogexa-provisioning-exadata-infrastructure.html"
      log "Cloud provisioning is not run here; use the vendor workflow after selecting and verifying project, region, quotas, permissions, and estimated charges."
      ;;
    4|"") log "Returning to setup selection." ;;
    *) warn "Unrecognized database option; returning to setup selection." ;;
  esac
}

vpn_setup_menu() {
  local choice
  echo "VPN options:"
  echo "1) WireGuard"
  echo "2) Libreswan (IPsec)"
  echo "3) Back to network setup"
  read -r -p "Choose a VPN option [3]: " choice || choice=3

  case ${choice:-3} in
    1)
      install_packages wireguard-tools
      if command -v wg >/dev/null 2>&1; then
        local key_dir="$HOME/.config/wireguard" private_key public_key
        install -d -m 700 "$key_dir"
        if [[ ! -s "$key_dir/privatekey" ]]; then
          private_key=$(wg genkey)
          printf '%s\n' "$private_key" >"$key_dir/privatekey"
          chmod 600 "$key_dir/privatekey"
        fi
        public_key=$(wg pubkey <"$key_dir/privatekey")
        printf 'WireGuard public key: %s\n' "$public_key"
        log "Private key saved with mode 600 at $key_dir/privatekey; it was not printed."
        log "Create and review /etc/wireguard/wg0.conf with your peer endpoint and AllowedIPs before enabling the tunnel."
        if ask_yes_no "Open UDP port 51820 in firewalld public zone for a WireGuard server" N; then
          if command -v firewall-cmd >/dev/null 2>&1 && as_root firewall-cmd --state >/dev/null 2>&1; then
            as_root firewall-cmd --permanent --zone=public --add-port=51820/udp
            as_root firewall-cmd --zone=public --add-port=51820/udp
          else
            warn "firewalld is not active; configure the host or upstream firewall separately."
          fi
        fi
      fi
      warn "Check support for this distribution and EL release. For Production purposes, Libreswan is the recommended option."
      ;;
    2)
      install_packages libreswan
      log "Libreswan installed. Configure /etc/ipsec.conf and /etc/ipsec.d/ with approved peer parameters and secrets before enabling ipsec."
      ;;
    3|"")
      log "Returning to network setup."
      ;;
    *)
      warn "Unrecognized VPN option; returning to network setup."
      ;;
  esac
}

network_setup_menu() {
  local choice
  echo "Network setup options:"
  echo "1) Configure VPN"
  echo "2) HA clustering"
  echo "3) HAProxy and Keepalived load balancing"
  echo "4) Skip"
  read -r -p "Choose a network option [4]: " choice || choice=4

  case ${choice:-4} in
    1)
      vpn_setup_menu
      ;;
    2)
      install_packages pcs pacemaker resource-agents fence-agents-all
      log "HA packages installed. Cluster fencing, quorum, node authentication, and network design must be completed before starting a cluster."
      if ask_yes_no "Open the firewalld high-availability service on this host" N; then
        if command -v firewall-cmd >/dev/null 2>&1 && as_root firewall-cmd --state >/dev/null 2>&1; then
          as_root firewall-cmd --permanent --add-service=high-availability
          as_root firewall-cmd --add-service=high-availability
        else
          warn "firewalld is not active; configure the host or upstream firewall separately."
        fi
      fi
      if ask_yes_no "Enable and start pcsd (cluster configuration is still required)" N; then
        as_root systemctl enable --now pcsd.service
      fi
      ;;
    3)
      install_packages haproxy keepalived
      log "HAProxy and Keepalived installed. Review /etc/haproxy/haproxy.cfg and /etc/keepalived/keepalived.conf before enabling either service."
      if ask_yes_no "Enable and start HAProxy and Keepalived now" N; then
        as_root systemctl enable --now haproxy.service keepalived.service
      fi
      ;;
    4|"")
      log "Skipping network setup."
      ;;
    *)
      warn "Unrecognized network option; skipping network setup."
      ;;
  esac
}

install_host_audit() {
  install_packages audit
  as_root systemctl enable --now auditd.service
  log "Audit daemon enabled. Review /etc/audit/rules.d/ and your approved audit policy before adding rules."
}

install_host_integrity() {
  install_packages aide
  local aide_db=/var/lib/aide/aide.db.gz
  if [[ -e $aide_db ]]; then
    log "AIDE baseline already exists at $aide_db; leaving it unchanged."
    return 0
  fi

  if ask_yes_no "Initialize the AIDE integrity baseline from the host's current state" N; then
    as_root aide --init
    if [[ -f /var/lib/aide/aide.db.new.gz ]]; then
      as_root install -o root -g root -m 0600 /var/lib/aide/aide.db.new.gz "$aide_db"
      log "Initial AIDE baseline created. Establish it only after validating the host is in a trusted state."
      log "Run 'sudo aide --check' for subsequent integrity checks."
    else
      warn "AIDE did not create the expected database at /var/lib/aide/aide.db.new.gz; consult its output and configuration."
    fi
  else
    log "AIDE installed; baseline initialization deferred until the host is trusted."
  fi
}

run_openscap_assessment() {
  local datastream="/usr/share/xml/scap/ssg/content/ssg-rl${EL_MAJOR}-ds.xml"
  local results_dir="$HOME/security-assessments"
  local timestamp report results

  install_packages openscap-scanner scap-security-guide
  if [[ ! -r $datastream ]]; then
    warn "SCAP Security Guide datastream not found at $datastream; no scan was run."
    return 1
  fi
  if ! ask_yes_no "Run a report-only OpenSCAP STIG assessment (no remediation)" N; then
    log "OpenSCAP installed; assessment deferred."
    return 0
  fi

  timestamp=$(date +%Y%m%d-%H%M%S)
  report="$results_dir/el${EL_MAJOR}-stig-${timestamp}.html"
  results="$results_dir/el${EL_MAJOR}-stig-${timestamp}.arf.xml"
  install -d -m 700 "$results_dir"
  log "Running report-only OpenSCAP STIG assessment; output will be saved under $results_dir."
  as_root oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_stig \
    --results-arf "$results" --report "$report" "$datastream"
  as_root chown "$USER":"$(id -gn)" "$report" "$results"
  chmod 600 "$report" "$results"
  log "OpenSCAP report: $report"
  log "OpenSCAP results: $results"
  warn "Review assessment findings and validate applicable policy requirements; this script does not remediate or certify compliance."
}

security_setup_menu() {
  local choice
  echo "Host security tools:"
  echo "1) Audit logging (auditd)"
  echo "2) File integrity monitoring (AIDE)"
  echo "3) OpenSCAP STIG assessment (report only)"
  echo "4) Smart card reader, token inspection, and issuance guidance"
  echo "5) Install audit, integrity, and OpenSCAP tools"
  echo "6) Skip"
  read -r -p "Choose a security option [6]: " choice || choice=6

  case ${choice:-6} in
    1) install_host_audit ;;
    2) install_host_integrity ;;
    3) run_openscap_assessment ;;
    4) smart_card_setup_menu ;;
    5)
      install_host_audit
      install_host_integrity
      run_openscap_assessment
      ;;
    6|"") log "Skipping host security tools." ;;
    *) warn "Unrecognized security option; skipping." ;;
  esac
}

smart_card_setup_menu() {
  local choice
  echo "Smart card support installs reader/token utilities only; it does not change PAM, SSSD, login policy, or card contents."
  echo "1) Install PC/SC reader service, CCID driver, and OpenSC tools"
  echo "2) Install tools and inspect connected readers/tokens"
  echo "3) Show token assignment, key generation, and certificate issuance workflow"
  echo "4) Skip"
  read -r -p "Choose a smart card option [4]: " choice || choice=4

  case ${choice:-4} in
    1|2)
      install_packages pcsc-lite pcsc-lite-ccid opensc
      as_root systemctl enable --now pcscd.socket
      log "Smart card tools installed. Insert the card and connect its reader before discovery."
      if [[ $choice == 2 ]]; then
        if command -v opensc-tool >/dev/null 2>&1; then
          opensc-tool --list-readers || warn "No smart card reader detected. Check USB passthrough, reader cabling, and pcscd status."
        fi
        if command -v pkcs11-tool >/dev/null 2>&1; then
          pkcs11-tool --module /usr/lib64/opensc-pkcs11.so --list-slots || \
            warn "No token slot found. Confirm the reader and card are supported and inserted."
        fi
        smart_card_issuance_guidance
      fi
      ;;
    3)
      smart_card_issuance_guidance
      ;;
    4|"")
      log "Skipping smart card setup."
      ;;
    *)
      warn "Unrecognized smart card option; skipping."
      ;;
  esac
}

smart_card_issuance_guidance() {
  cat <<'GUIDANCE'

Smart card token and certificate workflow:
  1. Confirm the reader and card are detected:
       opensc-tool --list-readers
       pkcs11-tool --module /usr/lib64/opensc-pkcs11.so --list-slots
  2. Inspect existing objects (the command prompts for the user PIN):
       pkcs11-tool --module /usr/lib64/opensc-pkcs11.so --slot <slot-id> --login --list-objects
  3. Token initialization/assignment is card-destructive and vendor-dependent.
     Follow the card issuer's approved provisioning instructions; do not initialize
     a card containing credentials. Never put PINs/PUKs in shell history or scripts.
  4. Generate the private key on-card using the issuer-approved key type and ID:
       pkcs11-tool --module /usr/lib64/opensc-pkcs11.so --slot <slot-id> --login \
         --keypairgen --key-type rsa:3072 --id <hex-id> --label <key-label>
     Verify the card supports the algorithm and security profile before proceeding.
  5. Create/submit a CSR using the organization's supported PKCS#11-aware CA client.
     Have the authorized CA issue the certificate, then import the issued certificate:
       pkcs11-tool --module /usr/lib64/opensc-pkcs11.so --slot <slot-id> --login \
         --write-object <issued-certificate.der> --type cert --id <hex-id> --label <cert-label>
  6. Verify the certificate and token objects with pkcs11-tool and the issuer's
     validation procedure. Configure user mapping and login only through the
     administrator-approved SSSD/PAM/authselect process.

These commands are examples: card models, middleware paths, PIN policy, key algorithms,
and certificate enrollment differ by issuer. No card writes, PIN changes, key generation,
certificate issuance, or login-policy changes are performed automatically by this script.
GUIDANCE
}

install_cockpit() {
  install_packages cockpit
  as_root systemctl enable --now cockpit.socket
}

install_github_cli() {
  if ! command -v gh >/dev/null 2>&1; then
    as_root dnf install -y 'dnf-command(config-manager)'
    as_root dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
    install_packages gh
  fi
  gh --version
}

github_account_setup_menu() {
  local choice
  if ! ask_yes_no "Install GitHub CLI (gh) and configure GitHub access" N; then
    return 0
  fi

  install_github_cli
  echo "GitHub does not accept account passwords for CLI authentication."
  echo "1) Create a GitHub account (opens the signup page)"
  echo "2) Sign in to an existing account using browser authentication and SSH"
  echo "3) Skip account setup"
  read -r -p "GitHub setup option [3]: " choice || choice=3

  case ${choice:-3} in
    1)
      printf '%s\n' "Create an account: https://github.com/signup"
      if [[ -n ${DISPLAY:-}${WAYLAND_DISPLAY:-} ]] && command -v xdg-open >/dev/null 2>&1; then
        xdg-open https://github.com/signup >/dev/null 2>&1 &
      fi
      log "After creating the account, rerun VS Code setup and choose existing-account sign-in."
      ;;
    2)
      log "Starting GitHub browser authentication. gh will prompt to use or create and upload an SSH key."
      gh auth login --hostname github.com --git-protocol ssh --web
      gh auth status --hostname github.com
      ;;
    3|"")
      log "GitHub CLI installed; account authentication skipped."
      ;;
    *)
      warn "Unrecognized GitHub setup option; account setup skipped."
      ;;
  esac
}

install_vscode() {
  local choice
  local ide_installed=false
  as_root rpm --import https://packages.microsoft.com/keys/microsoft.asc
  as_root rpm --import https://packages.microsoft.com/keys/microsoft-2025.asc 2>/dev/null || true
  as_root tee /etc/yum.repos.d/vscode.repo >/dev/null <<'REPO'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
REPO
  echo "1) VS Code  2) VS Code Insiders  3) Both  4) Skip"
  read -r -p "IDE choice [4]: " choice || choice=4
  case ${choice:-4} in
    1)
      install_packages code
      ide_installed=true
      ;;
    2)
      install_packages code-insiders
      ide_installed=true
      ;;
    3)
      install_packages code code-insiders
      ide_installed=true
      ;;
    *) log "Skipping VS Code installation." ;;
  esac
  if [[ $ide_installed == true ]]; then
    github_account_setup_menu
  fi
}

install_azure_cli() {
  local repo_url key_url
  if [[ $EL_MAJOR == 10 ]]; then
    repo_url=https://packages.microsoft.com/config/rhel/10/packages-microsoft-prod.rpm
    key_url=https://packages.microsoft.com/keys/microsoft-2025.asc
  else
    repo_url=https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm
    key_url=https://packages.microsoft.com/keys/microsoft.asc
  fi
  as_root rpm --import "$key_url"
  as_root dnf install -y "$repo_url"
  install_packages azure-cli
}

install_gcloud_cli() {
  if [[ $EL_MAJOR != 9 ]]; then
    warn "The configured Google Cloud CLI RPM repository is EL9-specific; skipping on EL$EL_MAJOR."
    return 1
  fi
  local gcloud_arch
  case $ARCH in
    x86_64) gcloud_arch=x86_64 ;;
    aarch64) gcloud_arch=aarch64 ;;
    s390x) warn "Google Cloud CLI RPM support for s390x was not verified; skipping."; return 1 ;;
  esac
  as_root tee /etc/yum.repos.d/google-cloud-sdk.repo >/dev/null <<REPO
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-${gcloud_arch}
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
REPO
  install_packages google-cloud-cli
}

install_ibm_cloud_cli() (
  local installer
  installer=$(mktemp)
  trap 'rm -f "$installer"' EXIT
  curl -fsSL https://clis.cloud.ibm.com/install/linux -o "$installer"
  sh "$installer"
  if ask_yes_no "Install every available IBM Cloud CLI plugin (large download)" N; then
    ibmcloud plugin install -a
  fi
  ibmcloud plugin list
)

install_oci_cli() (
  local installer
  installer=$(mktemp)
  trap 'rm -f "$installer"' EXIT
  curl -fsSL https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh -o "$installer"
  bash "$installer" --accept-all-defaults
  if [[ ! -f $HOME/.oci/config ]] && ask_yes_no "Run interactive OCI profile configuration now" N; then
    oci setup config
  fi
  oci --version
)

install_aws_cli() (
  local aws_arch temp_dir archive_url
  case $ARCH in
    x86_64) aws_arch=x86_64 ;;
    aarch64) aws_arch=aarch64 ;;
    *) warn "AWS CLI installer supports x86_64/aarch64 here; skipping $ARCH."; return 1 ;;
  esac
  temp_dir=$(mktemp -d)
  trap 'rm -rf "$temp_dir"' RETURN
  archive_url="https://awscli.amazonaws.com/awscli-exe-linux-${aws_arch}.zip"
  curl -fsSL "$archive_url" -o "$temp_dir/awscliv2.zip"
  curl -fsSL "${archive_url}.sig" -o "$temp_dir/awscliv2.sig"
  mkdir -m 700 "$temp_dir/gnupg"
  mkdir -m 700 "$temp_dir/gnupg"
  cat >"$temp_dir/aws-cli-public-key.asc" <<'AWSKEY'
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQINBF2Cr7UBEADJZHcgusOJl7ENSyumXh85z0TRV0xJorM2B/JL0kHOyigQluUG
ZMLhENaG0bYatdrKP+3H91lvK050pXwnO/R7fB/FSTouki4ciIx5OuLlnJZIxSzx
PqGl0mkxImLNbGWoi6Lto0LYxqHN2iQtzlwTVmq9733zd3XfcXrZ3+LblHAgEt5G
TfNxEKJ8soPLyWmwDH6HWCnjZ/aIQRBTIQ05uVeEoYxSh6wOai7ss/KveoSNBbYz
gbdzoqI2Y8cgH2nbfgp3DSasaLZEdCSsIsK1u05CinE7k2qZ7KgKAUIcT/cR/grk
C6VwsnDU0OUCideXcQ8WeHutqvgZH1JgKDbznoIzeQHJD238GEu+eKhRHcz8/jeG
94zkcgJOz3KbZGYMiTh277Fvj9zzvZsbMBCedV1BTg3TqgvdX4bdkhf5cH+7NtWO
lrFj6UwAsGukBTAOxC0l/dnSmZhJ7Z1KmEWilro/gOrjtOxqRQutlIqG22TaqoPG
fYVN+en3Zwbt97kcgZDwqbuykNt64oZWc4XKCa3mprEGC3IbJTBFqglXmZ7l9ywG
EEUJYOlb2XrSuPWml39beWdKM8kzr1OjnlOm6+lpTRCBfo0wa9F8YZRhHPAkwKkX
XDeOGpWRj4ohOx0d2GWkyV5xyN14p2tQOCdOODmz80yUTgRpPVQUtOEhXQARAQAB
tCFBV0MgQ0xJIFRlYW0gPGF3cy1jbGlAYW1hem9uLmNvbT6JAlQEEwEIAD4CGwMF
CwkIBwIGFQoJCAsCBBYCAwECHgECF4AWIQT7Xbd/1cEYuAURraimMQrMRnJHXAUC
aGveYQUJDMpiLAAKCRCmMQrMRnJHXKBYD/9Ab0qQdGiO5hObchG8xh8Rpb4Mjyf6
0JrVo6m8GNjNj6BHkSc8fuTQJ/FaEhaQxj3pjZ3GXPrXjIIVChmICLlFuRXYzrXc
Pw0lniybypsZEVai5kO0tCNBCCFuMN9RsmmRG8mf7lC4FSTbUDmxG/QlYK+0IV/l
uJkzxWa+rySkdpm0JdqumjegNRgObdXHAQDWlubWQHWyZyIQ2B4U7AxqSpcdJp6I
S4Zds4wVLd1WE5pquYQ8vS2cNlDm4QNg8wTj58e3lKN47hXHMIb6CHxRnb947oJa
pg189LLPR5koh+EorNkA1wu5mAJtJvy5YMsppy2y/kIjp3lyY6AmPT1posgGk70Z
CmToEZ5rbd7ARExtlh76A0cabMDFlEHDIK8RNUOSRr7L64+KxOUegKBfQHb9dADY
qqiKqpCbKgvtWlds909Ms74JBgr2KwZCSY1HaOxnIr4CY43QRqAq5YHOay/mU+6w
hhmdF18vpyK0vfkvvGresWtSXbag7Hkt3XjaEw76BzxQH21EBDqU8WJVjHgU6ru+
DJTs+SxgJbaT3hb/vyjlw0lK+hFfhWKRwgOXH8vqducF95NRSUxtS4fpqxWVaw3Q
V2OWSjbne99A5EPEySzryFTKbMGwaTlAwMCwYevt4YT6eb7NmFhTx0Fis4TalUs+
j+c7Kg92pDx2uQ==
=OBAt
-----END PGP PUBLIC KEY BLOCK-----
AWSKEY
  gpg --homedir "$temp_dir/gnupg" --import "$temp_dir/aws-cli-public-key.asc"
  gpg --homedir "$temp_dir/gnupg" --verify "$temp_dir/awscliv2.sig" "$temp_dir/awscliv2.zip"
  unzip -q "$temp_dir/awscliv2.zip" -d "$temp_dir"
  as_root "$temp_dir/aws/install" --update
  aws --version
)

install_cloud_clis() {
  ask_yes_no "Install Azure CLI" N && install_azure_cli || true
  ask_yes_no "Install AWS CLI v2" N && install_aws_cli || true
  ask_yes_no "Install Google Cloud CLI" N && install_gcloud_cli || true
  ask_yes_no "Install IBM Cloud CLI" N && install_ibm_cloud_cli || true
  ask_yes_no "Install Oracle Cloud CLI" N && install_oci_cli || true
}

install_ibm_z_tools() {
  local choice editor found_editor=false
  echo "IBM Z development uses client tools to connect to an existing z/OS system."
  echo "A reachable z/OSMF or RSE API endpoint and authorized account are required."
  echo "1) Zowe CLI with the CICS, Db2, MQ, and z/OS FTP plugins"
  echo "2) IBM Z Open Editor in installed VS Code builds"
  echo "3) Both"
  echo "4) LinuxONE/s390x documentation only"
  echo "5) Skip"
  read -r -p "IBM Z option [5]: " choice || choice=5
  case ${choice:-5} in
    1|3)
      if ! command -v npm >/dev/null 2>&1; then
        warn "Node.js/npm is required. Install the developer tool profile first."
      else
        npm install -g @zowe/cli@zowe-v3-lts
        zowe plugins install @zowe/cics-for-zowe-cli@zowe-v3-lts @zowe/db2-for-zowe-cli@zowe-v3-lts \
          @zowe/mq-for-zowe-cli@zowe-v3-lts @zowe/zos-ftp-for-zowe-cli@zowe-v3-lts
        zowe plugins list
      fi
      ;;&
    2|3)
      for editor in code code-insiders; do
        if command -v "$editor" >/dev/null 2>&1; then
          "$editor" --install-extension IBM.zopeneditor
          found_editor=true
        fi
      done
      [[ $found_editor == true ]] || warn "Install VS Code first to add IBM Z Open Editor."
      log "IBM Z Open Editor requires Java 21 or later; this script installs OpenJDK 21 in the developer profile."
      ;;
    4)
      printf '%s\n' "LinuxONE documentation: https://www.ibm.com/docs/en/linux-on-systems" \
        "Zowe CLI: https://docs.zowe.org/stable/user-guide/cli-installcli/"
      ;;
    5|"") log "Skipping IBM Z tools." ;;
    *) warn "Unrecognized IBM Z option; skipping." ;;
  esac
}

install_jenkins() {
  as_root wget -qO /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  install_packages fontconfig java-21-openjdk jenkins
  as_root systemctl daemon-reload
  as_root systemctl enable --now jenkins
}

install_grafana() {
  as_root tee /etc/yum.repos.d/grafana.repo >/dev/null <<'REPO'
[grafana]
name=Grafana OSS
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
REPO
  install_packages grafana
  as_root systemctl enable --now grafana-server
}

install_portainer() {
  install_packages podman
  as_root systemctl enable --now podman.socket
  if as_root podman container exists portainer; then
    as_root podman start portainer || true
  else
    as_root podman volume create portainer_data >/dev/null
    as_root podman run -d --name portainer --restart=always --privileged \
      -p 127.0.0.1:9443:9443 \
      -v /run/podman/podman.sock:/var/run/docker.sock \
      -v portainer_data:/data portainer/portainer-ce:lts
  fi
}

install_strelka() {
  local compose_file="$HOME/strelka"
  install_packages podman git
  if [[ ! -d $compose_file/.git ]]; then
    git clone https://github.com/target/strelka.git "$compose_file"
  fi
  if ! as_root podman compose version >/dev/null 2>&1; then
    warn "No Podman Compose provider is installed. Install one, then run the command below."
    printf '  cd %q && sudo podman compose -f build/docker-compose-no-build.yaml up -d\n' "$compose_file"
    return 1
  fi
  if ! grep -qE '^[[:space:]]*-[[:space:]]*"?[0-9]+:[0-9]+(/udp)?"?[[:space:]]*$' \
      "$compose_file/build/docker-compose-no-build.yaml"; then
    warn "Could not recognize the upstream published-port format; refusing to expose Strelka services."
    return 1
  fi
  sed -i -E \
    's/^[[:space:]]*-[[:space:]]*"?([0-9]+):([0-9]+)(\/udp)?"?[[:space:]]*$/      - "127.0.0.1:\1:\2\3"/' \
    "$compose_file/build/docker-compose-no-build.yaml"
  (cd "$compose_file" && as_root podman compose -f build/docker-compose-no-build.yaml up -d)
  warn "Strelka quickstart UI uses default credentials. Change them before exposing this service beyond localhost."
}

install_services() {
  if ask_yes_no "Install and start Cockpit" Y; then install_cockpit; fi
  if ask_yes_no "Install and start Grafana" N; then install_grafana; fi
  if ask_yes_no "Install and start Jenkins" N; then install_jenkins; fi
  if ask_yes_no "Install Portainer CE using rootful Podman (localhost only)" N; then install_portainer; fi
  if ask_yes_no "Clone and start the Strelka stack (includes Jaeger and Strelka UI)" N; then install_strelka; fi
}

is_http_ready() {
  local url=$1
  curl -kfsS --connect-timeout 2 --max-time 3 "$url" >/dev/null 2>&1
}

launch_browser_window() {
  local title=$1
  shift
  local browser
  for browser in firefox firefox-esr chromium chromium-browser google-chrome; do
    if command -v "$browser" >/dev/null 2>&1; then
      case $browser in
        firefox|firefox-esr) "$browser" --new-window "$@" >/dev/null 2>&1 & ;;
        *) "$browser" --new-window "$@" >/dev/null 2>&1 & ;;
      esac
      log "Opened $title browser window with $browser."
      return 0
    fi
  done
  return 1
}

write_bookmarks() {
  local output=$1
  shift
  {
    printf '%s\n' '<!DOCTYPE NETSCAPE-Bookmark-file-1>' '<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">' '<TITLE>Linux Setup</TITLE>' '<DL><p>'
    printf '  <DT><H3>%s</H3>\n  <DL><p>\n' "$output"
    while (($# >= 2)); do
      printf '    <DT><A HREF="%s">%s</A>\n' "$2" "$1"
      shift 2
    done
    printf '%s\n' '  </DL><p>' '</DL><p>'
  } > "$HOME/${output// /-}-bookmarks.html"
  log "Bookmarks saved to $HOME/${output// /-}-bookmarks.html"
}

open_guidance_windows() {
  local -a account_urls service_urls account_browser_urls service_browser_urls
  account_urls=(
    "Oracle Linux ULN" https://linux.oracle.com/ords/f?p=101:30
    "Oracle" https://www.oracle.com/
    "Oracle Cloud" https://cloud.oracle.com/
    "IBM" https://www.ibm.com/account/reg/us-en/signup
    "IBM Cloud" https://cloud.ibm.com/
    "Broadcom Support" https://support.broadcom.com/
    "Wave" https://www.waveapps.com/
    "Popl" https://popl.co/
    "GitHub" https://github.com/login
    "Microsoft Azure" https://portal.azure.com/
    "AWS" https://console.aws.amazon.com/
    "Google Cloud" https://console.cloud.google.com/
  )
  service_urls=()

  is_http_ready https://localhost:9090 && service_urls+=("Cockpit" https://localhost:9090)
  is_http_ready http://localhost:3000 && service_urls+=("Grafana" http://localhost:3000)
  is_http_ready http://localhost:8080 && service_urls+=("Jenkins" http://localhost:8080)
  is_http_ready https://localhost:9443 && service_urls+=("Portainer" https://localhost:9443)
  is_http_ready http://localhost:16686 && service_urls+=("Jaeger" http://localhost:16686)
  is_http_ready http://localhost:9980 && service_urls+=("Strelka UI" http://localhost:9980)

  local i
  for ((i=1; i<${#account_urls[@]}; i+=2)); do
    account_browser_urls+=("${account_urls[i]}")
  done
  for ((i=1; i<${#service_urls[@]}; i+=2)); do
    service_browser_urls+=("${service_urls[i]}")
  done

  if [[ -n ${DISPLAY:-}${WAYLAND_DISPLAY:-} ]] && command -v xdg-open >/dev/null 2>&1; then
    if ! launch_browser_window "account setup" "${account_browser_urls[@]}"; then
      warn "No supported browser executable found. Account portal URLs follow."
      for ((i=0; i<${#account_urls[@]}; i+=2)); do printf '%-20s %s\n' "${account_urls[i]}" "${account_urls[i+1]}"; done
    fi
    if ((${#service_urls[@]})); then
      if ! launch_browser_window "local services" "${service_browser_urls[@]}"; then
        warn "No supported browser executable found for service pages."
        for ((i=0; i<${#service_urls[@]}; i+=2)); do printf '%-20s %s\n' "${service_urls[i]}" "${service_urls[i+1]}"; done
      fi
    else
      log "No configured service endpoint responded; no services window opened."
    fi
  else
    log "No graphical browser session detected; writing bookmark files instead."
    write_bookmarks "Account Setup" "${account_urls[@]}"
    if ((${#service_urls[@]})); then
      write_bookmarks "Local Services" "${service_urls[@]}"
    else
      log "No local service endpoints responded."
    fi
  fi
}

main() {
  local selection item
  local -a selected_areas
  : > "$INSTALL_LOG"
  log "Starting $SCRIPT_NAME; log: $INSTALL_LOG"
  check_platform
  check_compliance_status

  cat <<'MENU'
Select setup areas (enter comma-separated numbers, or 'all'; 'q' quits):
  1) Developer tools
  2) Database / Oracle
  3) Network (VPN, HA, load balancing)
  4) Host security (audit, integrity, OpenSCAP, smart cards)
  5) Cloud CLIs
  6) IBM Z / COBOL tools
  7) Virtualization
  8) VS Code / Insiders
  9) Local services (Cockpit, Grafana, Jenkins, containers)
 10) All areas
MENU
  if [[ -n ${SETUP_AREAS:-} ]]; then
    selection=$SETUP_AREAS
    log "Using setup areas from SETUP_AREAS."
  elif [[ -t 0 ]]; then
    read -r -p "Setup areas [q]: " selection || selection=q
  else
    fail "No interactive terminal. Set SETUP_AREAS to a comma-separated list (for example: dev,db,net,sec)."
  fi

  [[ ${selection,,} != q ]] || { log "Setup cancelled by user."; return 0; }
  IFS=',' read -r -a selected_areas <<<"${selection,,}"
  if [[ " ${selected_areas[*]} " == *" 10 "* || " ${selected_areas[*]} " == *" all "* ]]; then
    selected_areas=(dev db net sec cloud ibmz virt ide services)
  fi

  install_base
  for item in "${selected_areas[@]}"; do
    case $item in
      1|dev|developer|developers)
        install_developer_tools
        ;;
      2|db|database|oracle)
        database_setup_menu
        ;;
      3|net|network|networking)
        network_setup_menu
        ;;
      4|sec|security)
        security_setup_menu
        ;;
      5|cloud|clis)
        install_cloud_clis
        ;;
      6|ibmz|cobol)
        install_ibm_z_tools
        ;;
      7|virt|virtualization)
        install_virtualization
        ;;
      8|ide|vscode)
        install_vscode
        ;;
      9|services|svc)
        install_services
        ;;
      *) warn "Unknown setup area '$item'; skipping it." ;;
    esac
  done

  open_guidance_windows
  log "Setup actions completed. Review $INSTALL_LOG and complete account login/profile setup in the opened portals."
}

main "$@"
