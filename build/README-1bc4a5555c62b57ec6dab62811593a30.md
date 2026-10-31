# Enterprise

This directory documents the enterprise operating model, including organizational entities and the technology capabilities that support them.

## Structure

- [Organization & Governance](organization-governance/README.md): corporate structure, subsidiaries, governance, legal, and shared services
	- [Subsidiaries](organization-governance/subsidiaries/README.md): one documentation area for each legal entity
- [Technology & Infrastructure](technology-and-infrastructure/README.md): platforms and engineering capabilities
	- [On-Premises](technology-and-infrastructure/on-premises/README.md)
	- [Development](technology-and-infrastructure/development/README.md)
	- [Cloud](technology-and-infrastructure/cloud/README.md)
	- [DevOps](technology-and-infrastructure/devops/README.md)

This keeps who the enterprise is separate from how the enterprise operates technically.

# Getting Started: Enterprise Architecture & Deployment Guide

A comprehensive guide for setting up enterprise infrastructure, managing identities, deploying applications, and implementing DevOps practices across multiple platforms and cloud providers.

**Estimated timeline:** 4-8 weeks for small-to-medium organizations (50-500 users)

## Enterprise Structure

- [Organization & Governance](organization-governance/README.md): corporate structure, subsidiaries, governance, legal, and shared services

---

## Table of Contents

1. [Enterprise Overview](#enterprise-overview)
2. [Phase 1: Planning and Assessment](#phase-1-planning-and-assessment)
3. [Phase 2: Email and Account Creation](#phase-2-email-and-account-creation)
4. [Phase 3: Integration and Security Setup](#phase-3-integration-and-security-setup)
5. [Phase 4: Rollout, Training, and Governance](#phase-4-rollout-training-and-governance)
6. [Architecture Patterns](#architecture-patterns)
7. [Deployment Strategies](#deployment-strategies)
8. [Kubernetes & Deployment Guide](#kubernetes--deployment-guide)
9. [Platform-Specific Guides](#platform-specific-guides)
10. [ServiceNow Integration](#servicenow-integration)
11. [Quick Links](#quick-links)

---

## Enterprise Overview

This roadmap assumes a **hybrid cloud enterprise environment** integrating:
- **Azure** (Microsoft 365/Entra ID)
- **Google Cloud Platform (GCP)**
- **Apple Services**
- **Multi-platform deployment** (Java/Spring, Python/Flask, .NET/Aspire, Rust, ROS 2, Q#)

**Key Principles:**
- Identity-first security model with zero-trust architecture
- Separation of concerns by platform function
- Centralized IAM via Azure Entra ID
- Compliance-first design (GDPR, HIPAA, SOX)
- Least privilege access and continuous verification

---

## Phase 1: Planning and Assessment

**Duration:** 1-2 weeks

### Tasks

1. **Assess Current Environment**
   - Inventory existing email systems and user directories
   - Evaluate current cloud usage and shadow IT
   - Identify compliance requirements (GDPR, HIPAA, SOX)
   - Determine data residency requirements

2. **Define User Roles and Access Levels**
   - Categorize users: Employees, contractors, external partners
   - Determine separation of concerns:
     - Azure: Internal productivity, Microsoft 365, identity management
     - GCP: Compute, storage, analytics workloads
     - Apple: Device management and authentication

3. **Choose Primary Identity Provider**
   - Select **Azure Entra ID** as central IAM hub
   - Plan federation with GCP and Apple via SAML/OAuth

4. **Budget and Procurement**
   - Acquire Azure subscriptions, GCP credits, Apple Business Manager licenses
   - Budget for third-party tools (BitTitan/Microsoft Mover for email migration)
   - Plan for implementation and professional services

---

## Phase 2: Email and Account Creation

**Duration:** 1-2 weeks

### 2.1 Set Up Azure Tenant and Entra ID

```bash
# Create Azure tenant via portal.azure.com
# 1. Create tenant in Azure Portal
# 2. Configure custom domain (e.g., @company.com)
# 3. Verify domain ownership via DNS
# 4. Enable Microsoft 365 services
```

**Steps:**
- Create Azure tenant via [portal.azure.com](https://portal.azure.com)
- Configure custom domain and verify ownership
- Enable Microsoft 365 for email (Exchange Online)
- Create initial admin accounts
- Set up **Multi-Factor Authentication (MFA)**
- Implement **Conditional Access Policies**

### 2.2 Create GCP Accounts

- Sign up via [console.cloud.google.com](https://console.cloud.google.com)
- Set up GCP organization and projects
- Create Google Workspace for email (Gmail) with same domain
- Enable domain verification
- Configure SSO via SAML (federate with Entra ID later)

### 2.3 Set Up Apple Accounts

- Enroll in [Apple Business Manager](https://business.apple.com)
- Create managed Apple IDs for users
- Configure Apple School Manager (if applicable for education)

### 2.4 Migrate or Create User Accounts

```bash
# Option 1: Sync from on-premises AD
# Using Azure AD Connect

# Option 2: Bulk import via CSV
# Use Microsoft 365 admin center for bulk user creation
```

**Methods:**
- Azure AD Connect for on-premises AD sync
- CSV bulk import via Microsoft 365 admin center
- Create email aliases/forwarding rules for unified access

### 2.5 Assign Licenses

| Platform | License Type | Best For |
|----------|-------------|----------|
| Azure | Microsoft 365 E3/E5 | Internal productivity, email, collaboration |
| GCP | Google Workspace Business | Compute workloads, cloud-native apps |
| Apple | Device Management Licenses | Device enrollment, MDM policies |

---

## Phase 3: Integration and Security Setup

**Duration:** 2-4 weeks

### 3.1 Federate Identities

**GCP Federation with Entra ID:**
```yaml
# SAML Configuration in GCP Workspace
# 1. Configure SAML SSO in GCP
# 2. Set up Entra ID as Identity Provider
# 3. Map Entra ID groups to GCP roles
# 4. Users inherit RBAC roles (e.g., GCP Storage Viewer)
```

**Apple Federation:**
- Use "Sign in with Apple" as external IdP in Entra ID External ID
- Map to Entra ID roles for conditional access
- Example: Apple users get limited access via RBAC policies

### 3.2 Configure Storage and Collaboration Tools

**Integrate Google Drive, Dropbox, OneDrive:**

```python
# Using Microsoft Graph API and Google Drive API
from msgraph.core import GraphClient
from google.oauth2.credentials import Credentials

# Sync files bidirectionally
# 1. Authenticate both accounts via OAuth
# 2. Select folders to sync
# 3. Set bidirectional sync (changes propagate)
```

**Options:**
- Use Microsoft Mover (mover.io) for migration/sync
- Use Zapier for automated workflows
- Implement API-based sync using Google Drive API + Microsoft Graph API

### 3.3 Implement Security Policies

- **Data Loss Prevention (DLP):** Prevent sensitive data leakage
- **Encryption:** Enable encryption at rest and in transit
- **Audit Logging:** Track all access and changes
- **Conditional Access:** Enforce MFA, device compliance, location-based policies

### 3.4 Test Access

- Pilot with small user group
- Validate SSO across platforms
- Test email routing and delivery
- Verify device enrollment
- Document issues and resolutions

---

## Phase 4: Rollout, Training, and Governance

**Duration:** 1-2 weeks

### 4.1 Full Rollout

- Migrate remaining users in waves
- Use phased deployment to minimize disruption
- Maintain rollback procedures
- Monitor each phase for issues

### 4.2 User Training

- Provide guides for accessing emails across platforms
- Training on Outlook, Gmail, Teams collaboration
- Manage device enrollment and MDM
- Document common troubleshooting steps

### 4.3 Monitoring and Compliance

- Set up Azure Monitor for Azure resources
- Configure GCP Cloud Logging
- Deploy Apple device management dashboards
- Establish security monitoring and alerting

### 4.4 Ongoing Management

- Establish change management procedures for new hires/terminations
- Schedule quarterly compliance audits
- Regular user access reviews (UAR)
- Maintain documentation in central wiki (SharePoint)

---

## Architecture Patterns

### Individual Backend Setup

**Linear Development Pipeline:**

```
1. Application Development
   ├── Choose Language/Framework
   ├── Develop Features
   └── Write Tests

2. Build Phase
   ├── Compile/Transpile
   ├── Run Tests
   ├── Code Quality Checks
   └── Generate Artifacts

3. Containerization
   ├── Create Dockerfile
   ├── Build Docker Image
   └── Test Container

4. Registry Push
   ├── Tag Image
   ├── Authenticate
   └── Push to Registry

5. Kubernetes Deployment
   ├── Create Deployment Manifest
   ├── Deploy to K8s Cluster
   ├── Configure Services
   └── Setup Ingress

6. Enterprise Integration
   ├── Connect to Services
   ├── Configure Logging
   ├── Setup Monitoring
   └── Enable Scaling
```

### Multi-Service Architecture

**Synchronous Communication (REST/gRPC):**
```
Service A → HTTP/gRPC → Service B → Database → Response
```

**Asynchronous Communication (Message Queue):**
```
Service A → Message Broker → Service B
Service A → Message Broker → Service C
Message Broker → Persistence → Replay
```

**Service Mesh (Istio):**
```
Ingress Gateway
    ↓
Virtual Service
    ↓
Destination Rule
    ↓
Service Mesh Sidecar
    ↓
Load Balancing
    ↓
Service Pod
```

### Database Architecture

**Java/Spring:**
- JPA/Hibernate ORM
- Spring Data repositories
- Database migrations (Flyway, Liquibase)
- Connection pooling (HikariCP)

**Python/Flask:**
- SQLAlchemy ORM
- Alembic migrations
- Async drivers (asyncpg, aiomysql)

**.NET/Aspire:**
- Entity Framework Core
- Dapper for micro-ORMs
- Multiple databases support

**Rust:**
- SQLx for type-safe SQL
- Tokio async runtime
- Connection pooling (r2d2, deadpool)

### Microservices Patterns

**API Gateway Pattern:**
```
Client → API Gateway → Service Mesh → Services
         ├─ Authentication
         ├─ Rate Limiting
         ├─ Request Routing
         ├─ Response Aggregation
         └─ Load Balancing
```

**Circuit Breaker Pattern:**
```
Healthy State
    ↓
Request Fails → Open State (Reject)
    ↓
Half-Open (Test Request)
    ↓
Success → Healthy / Failure → Open
```

**Saga Pattern (Distributed Transactions):**
```
Service A (Start) → Service B (Process) → Service C (Commit)
    ↓
All Succeed or Compensating Transactions Rollback
```

### Resilience Patterns

**Retry Logic:**
- Exponential Backoff
- Jitter to prevent thundering herd
- Max retries and timeouts
- Circuit breaker integration

**Bulkhead Pattern:**
```
Thread Pool A ─ Service A
Thread Pool B ─ Service B
Thread Pool C ─ Service C
(Isolation prevents cascading failures)
```

**Timeout Pattern:**
- Connection timeout
- Read timeout
- Overall request timeout

### Caching Strategies

**Cache-Aside (Lazy Loading):**
1. Request comes in
2. Check cache
3. Hit → Return
4. Miss → Query DB
5. Update cache
6. Return to client

**Write-Through:**
- Write to cache first
- Write to DB
- Return success

**Cache Invalidation:**
- TTL expiration
- Event-based invalidation
- LRU eviction
- Explicit invalidation

---

## Deployment Strategies

### Key Deployment Considerations

**Mise en Place (Preparation):**
1. Read requirements thoroughly
2. Gather all tools and resources
3. Prepare infrastructure
4. Organize workstation
5. Prepare equipment (pre-test, pre-configure)

**Think in Building Blocks:**
- Modular components
- Reusable patterns
- Composable services
- Version management

### Multi-Platform Support

| Platform | Framework | Package Manager | Build Tool | Container |
|----------|-----------|-----------------|-----------|-----------|
| Java | Spring Boot | Maven/Gradle | Gradle | Docker |
| Python | Flask/Django/FastAPI | pip | setuptools | Docker |
| .NET | Aspire/ASP.NET Core | NuGet | MSBuild | Docker |
| Rust | Cargo | Cargo | Cargo | Docker |
| C/C++ | Native | N/A | CMake | Docker |
| ROS 2 | Robotics OS | rosdep | colcon | Docker |
| Q# | Quantum | NuGet | dotnet | Docker |

### Cloud Providers

- **AWS:** AWS Portal, BrowserStack, Appium integration
- **Azure:** App Service, Functions, Container Apps, AKS
- **Google Cloud:** Cloud Run, Compute Engine, GKE
- **Oracle Cloud:** OCI Integration, Container Registry

### Development Workflow

```bash
# 1. Local Development
cd my-project
code .

# 2. Build Locally
docker build -t myapp:1.0 .
docker run -p 8080:8080 myapp:1.0

# 3. Test Container
# Run unit tests, integration tests

# 4. Push to Registry
docker tag myapp:1.0 registry.example.com/myapp:1.0
docker push registry.example.com/myapp:1.0

# 5. Deploy to Kubernetes
kubectl apply -f deployment.yaml

# 6. Verify Deployment
kubectl rollout status deployment/myapp
kubectl logs deployment/myapp
```

---

## Kubernetes & Deployment Guide

### Kubernetes Architecture

**Control Plane Components:**
- API Server: RESTful API for cluster management
- Scheduler: Assigns pods to nodes
- Controller Manager: Manages controllers
- etcd: Distributed key-value store for cluster state

**Worker Node Components:**
- kubelet: Node agent
- kube-proxy: Network proxy
- Container Runtime: Docker or containerd

### Core Kubernetes Objects

#### Namespaces

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: production
---
apiVersion: v1
kind: Namespace
metadata:
  name: staging
---
apiVersion: v1
kind: Namespace
metadata:
  name: development
```

#### Deployments

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deployment
  namespace: production
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: myapp
      version: v1
  template:
    metadata:
      labels:
        app: myapp
        version: v1
    spec:
      serviceAccountName: app-sa
      containers:
      - name: app
        image: registry/myapp:1.0
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080
          name: http
        env:
        - name: ENVIRONMENT
          value: "production"
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: password
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 512Mi
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
```

#### Services

```yaml
apiVersion: v1
kind: Service
metadata:
  name: app-service
  namespace: production
spec:
  type: ClusterIP
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
---
apiVersion: v1
kind: Service
metadata:
  name: app-loadbalancer
  namespace: production
spec:
  type: LoadBalancer
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
```

#### ConfigMaps and Secrets

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: production
data:
  app.properties: |
    log.level=INFO
    feature.flag=true
---
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
  namespace: production
type: Opaque
data:
  username: dXNlcm5hbWU=  # base64 encoded
  password: cGFzc3dvcmQ=  # base64 encoded
```

---

## Platform-Specific Guides

### Java / Spring Framework

**Project Setup:**
```bash
spring boot new --type gradle --language java \
  --name myapp \
  --package-name com.example.myapp
```

**Key Dependencies:**
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

**Docker Configuration:**
```dockerfile
FROM openjdk:17-jdk-alpine
COPY target/myapp.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**Best Practices:**
- Use Spring Boot for rapid development
- Implement Spring Security for authentication
- Use Spring Cloud for microservices
- Monitor with Spring Boot Actuator
- Externalize configuration with application.properties

---

### Python / Flask

**Project Structure:**
```
myapp/
├── app.py
├── config.py
├── requirements.txt
├── tests/
│   ├── __init__.py
│   └── test_app.py
└── Dockerfile
```

**Application Setup:**
```python
from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

**Docker Setup:**
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:5000"]
```

---

### .NET / Aspire

**Features:**
- Cloud-native .NET framework
- Entity Framework Core ORM
- Minimal APIs
- Built-in observability

**Project Setup:**
```bash
dotnet new aspire-starter -n myapp
cd myapp
dotnet build
```

---

### Rust / Cargo

**Features:**
- Memory-safe systems programming
- High-performance networking
- Type-safe SQL with SQLx
- Async runtime (Tokio)

**Project Setup:**
```bash
cargo new myapp
cd myapp
cargo add tokio actix-web
cargo build --release
```

---

### ROS 2 / Robotics

**Framework:** Robot Operating System 2
- Distributed computing for robotics
- DRAKE simulation integration
- Pub/Sub middleware
- Multi-language support (C++, Python)

---

### Q# / Quantum Computing

**Features:**
- Quantum computing with classical hybrid execution
- AI integration
- Job submission to quantum hardware
- QIR code preparation

---

## Implementation Roadmap

### Phase 1: Foundation Setup (Weeks 1-4)

**Objectives:**
- Establish Linux enterprise environment
- Deploy Docker containerization
- Deploy first application
- Create basic CI/CD pipeline

**Key Tasks:**
- [ ] Infrastructure provisioning (cloud VPC, security groups)
- [ ] Linux environment (RHEL/CentOS) with Docker
- [ ] Container registry setup (Docker Hub, JFrog, OCR)
- [ ] First application (Java/Python/.NET)
- [ ] CI/CD foundation (GitHub Actions, GitLab, Jenkins)

**Estimate:** 3-4 weeks

---

### Phase 2: Multi-Platform Support (Weeks 5-10)

**Objectives:**
- Integrate Java/Spring
- Integrate Python/Flask
- Integrate .NET/Aspire
- Standardize build processes
- Create framework templates

**Key Tasks:**
- [ ] Create Spring Boot template
- [ ] Create Flask project template
- [ ] Create .NET Aspire template
- [ ] Standardize build artifact naming
- [ ] Implement version management

**Estimate:** 5-6 weeks

---

### Phase 3: Kubernetes Orchestration (Weeks 11-16)

**Objectives:**
- Deploy AKS/GKE/EKS cluster
- Implement service mesh (Istio)
- Set up ingress and load balancing
- Configure autoscaling

**Key Tasks:**
- [ ] Provision Kubernetes cluster
- [ ] Deploy Istio service mesh
- [ ] Configure network policies
- [ ] Set up monitoring (Prometheus, Grafana)
- [ ] Implement autoscaling policies

**Estimate:** 6-8 weeks

---

### Phase 4: Enterprise Integration (Weeks 17-20)

**Objectives:**
- Integrate with identity management (Entra ID)
- Set up observability and logging
- Implement security policies
- Establish governance

**Key Tasks:**
- [ ] Identity federation setup
- [ ] Centralized logging (ELK, Splunk)
- [ ] Distributed tracing (Jaeger)
- [ ] Security scanning and compliance
- [ ] Backup and disaster recovery

**Estimate:** 4 weeks

---

## ServiceNow Integration

### Overview

ServiceNow provides IT Service Management (ITSM), asset management, and workflow automation capabilities.

**Important:** Ensure all processes are documented and sanctioned by IT/Security leadership.

### Requesting Access via ServiceNow

#### For Standard Users

1. **Search the Catalog:**
   - Log in to ServiceNow instance
   - Search for "Confluence Access," "Jira Access," or desired service

2. **Fill Out Request:**
   - Specify your role
   - Indicate required project/space
   - Request permission level (Read-only, Contributor, Admin)

3. **Approval Workflow:**
   - Request routes to manager or application owner
   - Approval is tracked and auditable

4. **Automated Provisioning:**
   - If IntegrationHub spoke is configured
   - User automatically added to correct group

#### For Admins (Setting Up Integration)

**Jira Spoke Configuration:**
```
1. Navigate to IntegrationHub > Spokes
2. Locate Jira Spoke for Jira Cloud
3. Generate Atlassian API Token from account security settings
4. Configure OAuth 2.0 connection
5. Map ServiceNow fields to Jira issues
```

**Confluence Spoke Configuration:**
```
1. Open Atlassian Developer Portal
2. Generate API Token
3. Configure Confluence Cloud Spoke in ServiceNow
4. Test user provisioning
5. Monitor sync status
```

### Onboarding Process

**After Access Approval:**

1. **Access Onboarding Dashboard:**
   - ServiceNow Employee Center
   - View "Journey" or "Onboarding Task List"
   - Microsoft Teams integration available

2. **Complete Excel-based Forms:**
   - Data imports via Microsoft 365 Excel Spoke
   - Sync with OneDrive/SharePoint
   - Equipment and skill tracking

3. **Sign PDF Documents:**
   - Sign via browser signature pad
   - Or use Adobe Acrobat Sign / DocuSign integration
   - Digital signatures legally binding

4. **Receive Outlook Notifications:**
   - Email alerts for each step
   - Actionable messages for approvals
   - Direct approval from email

### Budget for ServiceNow Implementation

**Industry Benchmarks (3x Rule):** For every $1 spent on licensing, expect $3 on implementation/maintenance.

| Category | Annual Cost | Notes |
|----------|-------------|-------|
| ServiceNow Licensing | $100-200/user/month | Basic ITSM vs. Pro tiers |
| Jira/Confluence | $22-49+/user/month | Standard vs. Premium |
| Integration Tools | $2,000-12,000+/year | IntegrationHub vs. third-party |
| Implementation | $30,000-150,000+ | Setup for mid-size to enterprise |
| Admin Salaries | $120,000+/year | Certified ServiceNow admin |

### Business Case for Sponsorship

**Executive Alignment:**
- **CIO:** Digital transformation, system-wide visibility
- **CTO:** IT Service Management + agile development alignment
- **VP IT Operations:** Reduce ticket resolution time, manual errors
- **Head of Engineering:** Cross-team collaboration, documentation

**Key Benefits:**
- **Operational Efficiency:** Automate support-to-dev workflow
- **Reduced Rework:** Eliminate manual data entry errors
- **Faster Resolution:** Real-time bi-directional sync
- **Enhanced Transparency:** Unified view across departments
- **Compliance & Auditability:** Permanent audit trail

---

## Quick Links

### Cloud Providers

| Service | Link | Purpose |
|---------|------|---------|
| Microsoft Azure | [portal.azure.com](https://portal.azure.com) | Cloud infrastructure, Microsoft 365 |
| Google Cloud | [console.cloud.google.com](https://console.cloud.google.com) | Compute, storage, analytics |
| AWS | [aws.amazon.com](https://aws.amazon.com) | Cloud infrastructure |
| Apple Business | [business.apple.com](https://business.apple.com) | Device management |
| IBM Cloud | [cloud.ibm.com](https://cloud.ibm.com) | Enterprise cloud services |

### Development Platforms

| Platform | Framework | Link | Purpose |
|----------|-----------|------|---------|
| Java | Spring Boot | [start.spring.io](https://start.spring.io) | Enterprise applications |
| Python | Flask | [flask.palletsprojects.com](https://flask.palletsprojects.com) | Web applications |
| .NET | Aspire | [learn.microsoft.com/aspire](https://learn.microsoft.com/en-us/dotnet/aspire/) | Cloud-native apps |
| Rust | Cargo | [rust-lang.org](https://www.rust-lang.org) | Systems programming |
| ROS 2 | Robotics | [docs.ros.org](https://docs.ros.org/en/humble/) | Robotics systems |

### DevOps & CI/CD

| Tool | Link | Purpose |
|------|------|---------|
| Azure DevOps | [dev.azure.com](https://dev.azure.com) | CI/CD, repos, pipelines |
| GitHub Actions | [github.com](https://github.com) | Workflow automation |
| GitLab | [gitlab.com](https://gitlab.com) | Git + CI/CD platform |
| Jenkins | [jenkins.io](https://www.jenkins.io) | Automation server |
| CircleCI | [circleci.com](https://circleci.com) | CI/CD platform |

### Collaboration & Documentation

| Tool | Link | Purpose |
|------|------|---------|
| Confluence | [atlassian.com/confluence](https://www.atlassian.com/software/confluence) | Team documentation |
| Jira | [atlassian.com/jira](https://www.atlassian.com/software/jira) | Issue tracking |
| Slack | [slack.com](https://slack.com) | Team communication |
| ServiceNow | [servicenow.com](https://www.servicenow.com) | IT Service Management |
| SharePoint | [microsoft.com/sharepoint](https://www.microsoft.com/en-us/microsoft-365/sharepoint/) | Team collaboration |

### Identity & Security

| Service | Link | Purpose |
|---------|------|---------|
| Azure Entra ID | [azure.microsoft.com/entra](https://www.microsoft.com/en-us/security/business/identity-access/microsoft-entra-id) | Cloud IAM |
| Okta | [okta.com](https://www.okta.com) | Identity management |
| Auth0 | [auth0.com](https://auth0.com) | Authentication platform |
| Ping Identity | [pingidentity.com](https://www.pingidentity.com) | Identity security |

---

## Key Learnings & Best Practices

### Preparation (Mise en Place)
1. Read requirements thoroughly
2. Gather all tools and resources
3. Prepare infrastructure and services
4. Organize workstation with everything accessible
5. Don't get lost in the details

### Architecture Principles
- **Think Modular:** Lego blocks, building blocks, TETRIS-like composition
- **Learn From Others:** NYSE, market leaders, industry standards
- **Embrace Diversity:** Multiple platforms, frameworks, cloud providers
- **Document Everything:** Central wiki, runbooks, playbooks

### Security First
- **Zero Trust:** Least privilege, continuous verification
- **MFA Everywhere:** Multi-factor authentication mandatory
- **Encryption:** At rest and in transit
- **Audit Logging:** Complete audit trail for compliance

### Operations Excellence
- **Automation:** Infrastructure as Code, CI/CD pipelines
- **Monitoring:** Observability, logging, distributed tracing
- **Resilience:** Circuit breakers, retries, bulkheads
- **Scalability:** Horizontal scaling, load balancing, autoscaling

---

## Additional Resources

- [MITRE ATT&CK](https://attack.mitre.org/) - Adversary tactics and techniques
- [CIS Controls](https://www.cisecurity.org/cis-controls/) - Critical security controls
- [Zero Security YouTube](https://www.youtube.com/zsecurity) - Security education
- [CNCF Landscape](https://landscape.cncf.io/) - Cloud-native tools and services

---

**Last Updated:** 2026-08-26  
**Status:** Ready for Implementation  
**Audience:** Enterprise Architects, DevOps Engineers, System Administrators
