# Technology & Infrastructure

This area documents the platforms and engineering capabilities used to build, run, secure, and deliver enterprise systems.

## Navigation

Use this page as the entry point for technology and infrastructure documentation. The folders remain organized by capability, so pages can be moved between domains without changing the overall navigation model.

### 1. Foundations & Systems

- [Linux & System Administration](02_linux/README.md): operating systems, installation, security, networking, and setup automation
- [On-Premises](on-premises/README.md): company-controlled facilities and private infrastructure
- [Kubernetes and Local Clusters](02_linux/Kube/index.md): cluster configuration, local environments, and node setup

### 2. Cloud & Platforms

- [Cloud](cloud/README.md): hosted platforms, tenancy, identity, networking, and cloud operating practices
- [Cloud Data & Storage](cloud/Cloud.md): cloud service notes and platform-specific storage guidance

### 3. Delivery & Operations

- [DevOps](devops/README.md): delivery automation, containers, orchestration, infrastructure as code, releases, and monitoring
- [Development Operations](development/README.md): developer environments, application platforms, and engineering workflows
- [Linux Setup](02_linux/setup/README.md): reusable system setup and security scripts
- [Virtualization & Endpoint Environments](02_linux/setup-1/README.md): cloud VM, VDI, endpoint, and virtualization setup notes

### 4. Application Development & Data

- [Development](development/README.md): application development standards, languages, frameworks, testing, and internal platforms
- [Data Engineering](development/data/data.md): data cleaning, HDF5, Parquet, and data-processing workflows
- [APIs & Data Services](api.md): API design, OpenAPI, FastAPI, and public data services

### 5. Security & Governance

- [Security](Security/README.md): security practices, controls, and reference material
- [Linux Security](02_linux/setup/el9_sec.md): Enterprise Linux security configuration
- [Infrastructure Security](Security/Security.md): broader infrastructure and platform security guidance

### 6. Specialized Infrastructure

- [Geospatial Analytics](Geospatial_Analytics/index.md): mapping platforms, Earth observation, GIS, and spatial data services
- [Spectrum Management](spectrum-mngmt.md): wireless spectrum, CBRS, dynamic access, and interference management
- [Greenfield](Greenfield/fields.md): new platform and infrastructure initiatives

### Filing Rules

- Put operating-system and host configuration under `02_linux/`.
- Put provider-specific services under `cloud/`.
- Put deployment, automation, and runtime operations under `devops/`.
- Put application, API, and data-processing material under `development/`.
- Put controls, hardening, and compliance material under `Security/`.
- Put domain-specific platforms, such as GIS or spectrum systems, in their own named folder at this level.
- Keep each directory's `README.md` focused on orientation and move long technical notes into named topic files.

### Target Directory Map

When physical folders are reorganized, use this structure as the canonical destination map:

```text
technology-and-infrastructure/
├── foundations/
│   ├── linux/                 # current: 02_linux/
│   ├── kubernetes/            # current: 02_linux/Kube/
│   └── on-premises/           # current: on-premises/
├── platforms/
│   ├── cloud/                 # current: cloud/
│   ├── geospatial/            # current: Geospatial_Analytics/
│   ├── greenfield/            # current: Greenfield/
|   └── spectrum/              # current: spectrum-mngmt.md
├── engineering/
│   ├── development/           # current: development/
│   ├── data/                  # current: development/data/
│   ├── api/                   # current: api.md
│   └── devops/                # current: devops/
└── security/
    └── infrastructure/        # current: Security/
```

Keep the current paths until all Markdown links, TOC entries, image references, and build outputs are updated together.

### Architecture & Platforms

Core operating systems, development environments, and platforms.

| Linux | Windows | Other Platforms |
|---|---|---|
| **Oracle Linux ISOs**<br>![Linux Distros logo](https://www.kernel.org/theme/images/logos/favicon.png)<br>[Download](https://yum.oracle.com/oracle-linux-isos.html)<br>Official Oracle Linux ISO downloads for enterprise deployments. | **Windows ISOs**<br>![Windows logo](https://www.microsoft.com/favicon.ico?v2)<br>[Downloads](https://www.microsoft.com/en-us/software-download/)<br>Official Microsoft Windows ISO downloads for installation and recovery. | **FreeBSD**<br>![FreeBSD logo](https://docs.freebsd.org/favicon.ico)<br>[Website](https://www.freebsd.org/)<br>Advanced open source Unix-like operating system for servers, desktops, and embedded platforms. |
| **Oracle Linux Docs**<br>![Oracle Linux logo](https://docs.oracle.com/sp_common/site-template/ohc-common/img/o-icon/favicon.ico)<br>[Documentation](https://docs.oracle.com/en/operating-systems/oracle-linux/9/)<br>Documentation for Oracle Linux 9, including installation and administration guides. | **Windows Server ISOs**<br>![Windows Server logo](https://www.microsoft.com/favicon.ico?v2)<br>[Evaluation Center](https://www.microsoft.com/en-us/evalcenter)<br>Evaluation and trial ISOs for Microsoft Windows Server editions. | **systemd**<br>![systemd logo](https://systemd.io/images/systemd-logo.png)<br>[Website](https://systemd.io/)<br>A suite of basic building blocks for a Linux system. |
| **Alpine Linux**<br>![Alpine logo](https://alpinelinux.org/alpine-logo.ico)<br>[Downloads](https://alpinelinux.org/downloads/)<br>Minimalist Linux distribution for containers and security-focused deployments. | - | - |
| **CentOS**<br>![CentOS logo](https://www.centos.org/assets/icons/apple-touch-icon.png)<br>[Website](https://www.centos.org/)<br>Community-driven free software effort focused on delivering a robust open source ecosystem. | - | - |
| **Debian**<br>![Debian logo](https://www.debian.org/favicon.ico)<br>[Website](https://www.debian.org/)<br>Universal operating system known for stability and a vast package repository. | - | - |
| **Ubuntu**<br>![Ubuntu logo](https://assets.ubuntu.com/v1/f38b9c7e-COF%20apple-touch-icon.png)<br>[Website](https://www.ubuntu.com/)<br>Popular Linux distribution for desktops, servers, and cloud, with ROS2 and Gazebo support. | - | - |
| **SUSE**<br>![SUSE logo](https://www.suse.com/favicon.ico)<br>[Website](https://www.suse.com/)<br>Enterprise Linux distribution for mission-critical workloads and cloud infrastructure. | - | - |
| **Kali Linux**<br>![Kali Linux logo](https://upload.wikimedia.org/wikipedia/commons/2/2b/Kali-dragon-icon.svg)<br>[Tools](https://www.kali.org/tools/)<br>Penetration testing and security auditing Linux distribution with hundreds of tools. | - | - |
