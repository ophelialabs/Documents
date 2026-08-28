---
title: Scientific Data Formats & Hyrax/HDF5 Integration  
description: Comprehensive guide to storing, accessing, and querying large scientific datasets using NetCDF, HDF5, ASDF, and OPeNDAP servers
---

# Scientific Data Formats & Hyrax/HDF5 Integration

## Overview

Scientific data formats like NetCDF, HDF5, and ASDF provide structured ways to store, organize, and share massive datasets. This guide covers data format selection, Hyrax/HDF5 server architecture, authentication patterns, and multi-cloud deployment strategies.

### Resources

- [Data Lake Analytics](https://azure.microsoft.com/en-us/products/data-lake-analytics/)
- [Apache Iceberg](https://www.ibm.com/think/topics/apache-iceberg)
- [IBM Big Data Analytics](https://www.ibm.com/think/topics/big-data-analytics)

---

## Data Formats Comparison

### NetCDF (Network Common Data Form)

**Core Strength:** Widely used in climate, ocean, and atmospheric sciences with strict Climate and Forecast (CF) convention adherence.

**Implementation:** Modern NetCDF-4 uses HDF5 as storage layer, combining NetCDF data model with HDF5's compression and chunking features.

**Limitation:** Enforces strictly hierarchical structure; does not support HDF5 "cycles" feature.

### HDF5 (Hierarchical Data Format v5)

**Core Strength:** Designed for extremely large, complex datasets; functions like a "file system within a file."

**Implementation:** Advanced features include parallel I/O critical for HPC workloads.

**Limitation:** Flexibility can lead to poorly documented files without explicit conventions.

### ASDF (Advanced Scientific Data Format)

**Core Strength:** Combines human-readable YAML metadata with binary data; self-documenting with JSON Schema validation.

**Implementation:** Frequently used in astronomy (e.g., James Webb Space Telescope).

**Limitation:** Smaller ecosystem compared to NetCDF/HDF5 communities.

### Quick Selection Guide

| Feature | NetCDF-4 | HDF5 | ASDF |
|---------|----------|------|------|
| Primary Use | Geosciences, Climate | General HPC, Large Datasets | Astronomy, Python-centric |
| Metadata | CF Conventions | Highly Flexible / Custom | Human-readable YAML |
| Structure | Strictly Hierarchical | Any Graph (cycles allowed) | Hierarchical |
| Storage Backend | HDF5 | Native HDF5 | YAML + Binary |

---

## Hyrax & HDF5 Integration

### The Relationship

- **Hyrax:** OPeNDAP Data Server for internet-based scientific data access; enables subsetting without full downloads
- **HDF5:** File format for massive datasets (satellite imagery, climate models)
- **Handler:** Hyrax HDF5 Handler translates files into web-accessible format

### Key Capabilities

- **Subsetting:** Request only needed variables/regions, saving bandwidth
- **Cloud Optimization:** DMR++ enables direct S3 access for cloud-hosted HDF5 data
- **Interoperability:** Serve to Python (h5py), MATLAB, GIS software
- **NASA Support:** Standard for Earth Observing System (EOS) data access

---

## Querying Hyrax/HDF5 Data

### Web Interface

1. Navigate to dataset on Hyrax catalog
2. Click dataset name → find "OPeNDAP Dataset Access Form"
3. Select variables and apply constraints
4. Optionally specify hyperslabs: `[start:stride:stop]`
5. Copy generated URL or download directly

### Programmatic Queries (Python)

```python
from pydap.client import open_url

url = 'http://your-server-address/opendap/path/to/data.h5'
dataset = open_url(url, protocol='dap4')
print(dataset.tree())

variable = dataset['variable_name']
data_subset = variable[0:10]
```

### Query URL Syntax

- Variable Selection: `...data.h5?variable1,variable2`
- Spatial Subsetting: `...data.h5?variable1[0:1:100][0:1:100]`
- Metadata Queries: Append `.das` or `.dds` for structure without data

### Xarray (High-level)

```python
import xarray as xr

ds = xr.open_dataset('https://your-private-server.com', engine='netcdf4')
```

---

## Authentication

### Basic Authentication (.netrc)

**Linux/Mac:**
```bash
touch ~/.netrc && chmod 600 ~/.netrc
```

**Content:**
```text
machine your-server-address.com
login your_username
password your_password
```

### Common Methods

- **Apache/Basic Auth:** `.netrc` file usually sufficient
- **Earthdata Login (NASA):** Requires EDL profile approval
- **DODS Configuration:** Legacy clients may need `.dodsrc`

---

## OAuth2 Token Discovery

### Standard Discovery Endpoints

- **OIDC:** `https://[auth-server]/.well-known/openid-configuration`
- **OAuth2:** `https://[auth-server]/.well-known/oauth-authorization-server`

### Common Patterns

- General: `https://[auth-server]/oauth2/token`
- Keycloak: `https://[server]/realms/[realm]/protocol/openid-connect/token`
- Okta: `https://[org].okta.com/oauth2/v1/token`
- NASA: `https://urs.earthdata.nasa.gov/oauth/token`

### Automated Discovery

```python
import requests

def discover_token_endpoint(auth_server_url):
    discovery_paths = [
        "/.well-known/openid-configuration",
        "/.well-known/oauth-authorization-server"
    ]
    
    auth_server_url = auth_server_url.rstrip('/')
    
    for path in discovery_paths:
        ping_url = f"{auth_server_url}{path}"
        try:
            response = requests.get(ping_url, timeout=5)
            if response.status_code == 200:
                config = response.json()
                if 'token_endpoint' in config:
                    return config['token_endpoint']
        except requests.exceptions.RequestException as e:
            print(f"Failed to reach {ping_url}: {e}")
    
    return None

token_url = discover_token_endpoint("https://your-auth-server.com")
```

### Token Exchange

```python
import requests

def get_access_token(endpoint, client_id, client_secret):
    payload = {
        'grant_type': 'client_credentials',
        'client_id': client_id,
        'client_secret': client_secret
    }
    
    try:
        response = requests.post(endpoint, data=payload, timeout=10)
        response.raise_for_status()
        return response.json().get('access_token')
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")
        return None

access_token = get_access_token("https://your-auth-server.com/oauth/token", 
                                "YOUR_CLIENT_ID", "YOUR_CLIENT_SECRET")
```

**Notes:**
- Most OAuth2 servers expect credentials in request body
- Some require Authorization Header: add `auth=(client_id, client_secret)`
- Some require specific scopes: `'scope': 'openid profile data_read'`
- Tokens typically expire in 3600 seconds

---

## Multi-Cloud Deployment

### Kubernetes ConfigMap + Deployment

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: hyrax-client-config
data:
  AUTH_SERVER_BASE: "https://auth.yourorg.com"
  TOKEN_ENDPOINT: "https://auth.yourorg.com/oauth/token"
  S3_BUCKET_NAME: "scientific-data-bucket"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hyrax-query-client
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hyrax-client
  template:
    metadata:
      labels:
        app: hyrax-client
    spec:
      initContainers:
      - name: check-bucket-exists
        image: amazon/aws-cli:latest
        env:
        - name: BUCKET_NAME
          valueFrom:
            configMapKeyRef:
              name: hyrax-client-config
              key: S3_BUCKET_NAME
        command:
        - "/bin/sh"
        - "-c"
        - "aws s3api head-bucket --bucket $BUCKET_NAME || exit 1"
      
      containers:
      - name: app
        image: your-registry/hyrax-python-client:latest
        envFrom:
        - configMapRef:
            name: hyrax-client-config
        env:
        - name: CLIENT_ID
          valueFrom:
            secretKeyRef:
              name: oauth-secrets
              key: client-id
        - name: CLIENT_SECRET
          valueFrom:
            secretKeyRef:
              name: oauth-secrets
              key: client-secret
```

### GKE + AWS Workload Identity Federation

```bash
# GKE: Create Google Service Account
gcloud iam service-accounts create gke-s3-ping-sa \
    --display-name="GKE S3 Access SA"

# GKE: Bind Kubernetes SA to Google SA
gcloud iam service-accounts add-iam-policy-binding gke-s3-ping-sa@[PROJECT_ID].iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:[PROJECT_ID].svc.id.goog[[NAMESPACE]/[KSA_NAME]]"

# AWS: Create OIDC Provider
aws iam create-open-id-connect-provider \
    --url "https://accounts.google.com" \
    --client-id-list "https://[PROJECT_ID].svc.id.goog" \
    --thumbprint-list "08745487F891DC29E307135A4AF03949D6A129E9"
```

### AWS IAM Policy for S3

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Layer2BucketPing",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::your-scientific-data-bucket"
        }
    ]
}
```

---

## Health Checks & Reliability

### Multi-Layer Health Check Script

```bash
#!/bin/bash

HYRAX_HOST=${HYRAX_HOST:-"hyrax-server.org"}
HYRAX_URL="https://${HYRAX_HOST}/opendap/test_data.h5"
S3_BUCKET=${S3_BUCKET_NAME}
TOKEN_DISCOVERY_URL="https://${AUTH_SERVER_BASE}/.well-known/openid-configuration"

echo "--- Starting Multi-Layer Health Check ---"

# Layer 3: Network Ping
nc -zv -w 2 "$HYRAX_HOST" 443 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "[L3 SUCCESS] Network connectivity established."
else
    echo "[L3 FAILURE] Cannot reach $HYRAX_HOST on port 443."
    exit 1
fi

# Layer 2: Identity & Storage Ping
if [ -n "$S3_BUCKET" ]; then
    aws s3api head-bucket --bucket "$S3_BUCKET" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "[L2 SUCCESS] S3 Bucket '$S3_BUCKET' accessible."
    else
        echo "[L2 FAILURE] Access denied or bucket not found: $S3_BUCKET."
        exit 1
    fi
fi

# Layer 1: Protocol Discovery Ping
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$TOKEN_DISCOVERY_URL")
if [ "$HTTP_CODE" -eq 200 ]; then
    echo "[L1 SUCCESS] OAuth2 Discovery endpoint responsive."
else
    echo "[L1 FAILURE] Auth server returned HTTP $HTTP_CODE."
    exit 1
fi

# Layer 7: Application Semantic Ping
HYRAX_PING=$(curl -s -I "${HYRAX_URL}.das" | grep "HTTP" | awk '{print $2}')
if [ "$HYRAX_PING" -eq 200 ] || [ "$HYRAX_PING" -eq 401 ]; then
    echo "[L7 SUCCESS] Hyrax HDF5 Handler operational."
else
    echo "[L7 FAILURE] Hyrax returned unexpected HTTP $HYRAX_PING."
    exit 1
fi

echo "--- All Layers Healthy ---"
exit 0
```

### Kubernetes Readiness Probe

```yaml
spec:
  containers:
  - name: hyrax-client
    image: your-app-image:latest
    readinessProbe:
      exec:
        command:
        - /bin/bash
        - /scripts/healthcheck.sh
      initialDelaySeconds: 10
      periodSeconds: 30
      timeoutSeconds: 5
    volumeMounts:
    - name: healthcheck-script
      mountPath: /scripts
  volumes:
  - name: healthcheck-script
    configMap:
      name: hyrax-health-cfg
      defaultMode: 0755
```

---

## Docker: Multi-Cloud Alpine Image

```dockerfile
FROM alpine:3.19

ENV GLIBC_VER=2.35-r1

# Install core dependencies
RUN apk add --no-cache \
    curl binutils bash python3 py3-pip ca-certificates \
    libstdc++ util-linux netcat-openbsd

# Install glibc compatibility layer (for AWS CLI v2)
RUN curl -sLO https://alpine-pkgs.sgerrand.com && \
    mv sgerrand.rsa.pub /etc/apk/keys/sgerrand.rsa.pub && \
    curl -sLO https://github.com{GLIBC_VER}/glibc-${GLIBC_VER}.apk && \
    curl -sLO https://github.com{GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk && \
    apk add --no-cache glibc-${GLIBC_VER}.apk glibc-bin-${GLIBC_VER}.apk && \
    rm glibc-${GLIBC_VER}.apk glibc-bin-${GLIBC_VER}.apk

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com" -o "awscliv2.zip" && \
    unzip awscliv2.zip && ./aws/install && rm -rf awscliv2.zip ./aws

# Install Google Cloud SDK
RUN curl -sSL https://sdk.cloud.google.com | bash -s -- --disable-prompts --install-dir=/opt
ENV PATH $PATH:/opt/google-cloud-sdk/bin

# Install Azure CLI
RUN apk add --no-cache --virtual .build-deps gcc musl-dev python3-dev libffi-dev openssl-dev make && \
    pip3 install --upgrade pip && pip3 install azure-cli && \
    apk del .build-deps

WORKDIR /scripts
COPY healthcheck.sh /scripts/healthcheck.sh
RUN chmod +x /scripts/healthcheck.sh

CMD ["/bin/bash", "/scripts/healthcheck.sh"]
```

**Build & Push:**
```bash
docker build -t your-registry/multi-cloud-ping:latest .
docker push your-registry/multi-cloud-ping:latest
```

---

## Resource Links

- [OPeNDAP Data Server](https://www.opendap.org/)
- [HDF5 Documentation](https://www.hdfgroup.org/solutions/hdf5/)
- [NASA Earthdata Login](https://urs.earthdata.nasa.gov/)
- [Kubernetes Workload Identity](https://cloud.google.com/docs/authentication/workload-identity)
