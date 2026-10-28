---
title: Getting Started
---

## Lets get started!
I have tried to set up the documentation this way so that the focus is on integrating Linux Cockpit, the Prometheus dashboard so as to get more familiar with the layout and additional tools that the Cockpit manager provides in addition to Podman. For this reason, I will **NOT** be utilizing or suggesting Docker (Podman/Docker commands are interchangeable). 

---

Avoiding the `:latest` tag in container images is critical for stability because it is **mutable**, meaning it can point to different, untested versions over time, leading to unpredictable breaks. It prevents easy rollbacks, causes non-reproducible deployments, makes auditing impossible, and allows for potential software supply chain attacks.

**Key Reasons to Avoid `:latest` Tags:**
- **Non-Reproducible Builds:** Using `:latest` means your container can change between deployments, making debugging nearly impossible.
- **Production Instability:** A new `:latest` image might include breaking changes, bugs, or untested code, leading to unexpected application failures.
- **Difficult Rollbacks:** If an image updates, you cannot easily revert to the previous "last known good" version because the tag now points to the new, broken version.
- **Security Risks:** Without a specific version tag, you may be running an untested image that contains vulnerabilities.
- **Poor Auditing/Compliance:** It is impossible to determine which exact version of an image is running in production.
- **Overwriting Risk:** The `:latest` tag is easily and frequently overwritten by automated pipelines or manual pushes.

Best Practice: Use specific, immutable tags (e.g., `:1.2.3` or a git commit hash) for all production deployments to guarantee consistency and security.

---

# Clone GKE retail [example](https://github.com/GoogleCloudPlatform/microservices-demo)
```bash
git clone --depth 1 --branch v0 https://github.com/GoogleCloudPlatform/microservices-demo.git
cd microservices-demo/
```
- Export Google Cloud project and region and ensure the Google Kubernetes Engine API is enabled
- Substitute <PROJECT_ID> with the ID of your Google Cloud project
```bash
export PROJECT_ID=<PROJECT_ID>
export REGION=us-central1
gcloud services enable container.googleapis.com \
  --project=${PROJECT_ID}
```
- Create a GKE cluster and get the credentials for it
```bash
gcloud container clusters create-auto online-boutique \
  --project=${PROJECT_ID} --region=${REGION}
```
- Deploy App to cluster
```bash
kubectl apply -f ./release/kubernetes-manifests.yaml
```
- Access the web frontend in a browser using the frontend's external IP
- Visit http://EXTERNAL_IP in a web browser to access your instance
```bash
kubectl get service frontend-external | awk '{print $4}'
```
- Delete cluster when finished
```bash
gcloud container clusters delete online-boutique \
  --project=${PROJECT_ID} --region=${REGION}
```
## Addition deployment options
 - [Terraform](https://github.com/GoogleCloudPlatform/microservices-demo/blob/main/terraform)
 - [Istio/Cloud](https://github.com/GoogleCloudPlatform/microservices-demo/blob/main/kustomize/components/service-mesh-istio/README.md) Service Mesh
 - [Non-GKE](https://github.com/GoogleCloudPlatform/microservices-demo/blob/main/docs/development-guide.md) (Minikube, Kind)
 - [AI](https://github.com/GoogleCloudPlatform/microservices-demo/blob/main/kustomize/components/shopping-assistant/README.md) assistant using Gemini
 - [/kustomize](https://github.com/GoogleCloudPlatform/microservices-demo/tree/main/kustomize) directory contains instructions for customizing the deployment of Online Boutique with other variations

---
title: Install and tool setup
---

# KUBERNETES
- [Docs](https://kubernetes.io/docs/home/)
Detect OS and arch 
Linux (x86-64 , ARM64)
MacOS (Intel , Silicon(M4))
Windows (amd64 , arm64)

Deb 
kubectl

macos 
kubectl 

Still Need
kubelet 
kubeadm 
cri-tools 
kubernetes-cni

(visit linux setup & remember curl(terminal) bypasses Mac's gatekeeper)

-------------
# Linux

# Kubectl
# Deb (Ubuntu)
$ sudo apt-get update
$ sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
$ sudo touch mkdir -p -m 755 /etc/apt/keyrings
$ curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
$ sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
$ echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
$ sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
$ sudo rm 
$ sudo apt-get update
$ sudo apt-get install -y kubectl

-----------------------------------

# RHEL (Oracle Linux)
# Add yum repo
$ cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/repodata/repomd.xml.key
EOF
$ sudo yum install -y kubelet kubeadm kubectl cri-tools kubernetes-cni --disableexcludes=kubernetes
$ systemctl enable --now kubelet
$ go install sigs.k8s.io/kind@v0.27.0
$ sudo mv ~/go/bin/kind /bin
$ sudo rm -r ~/go
$ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
$ sudo rpm -Uvh minikube-latest.x86_64.rpm
```
# SUSE-based Distros
# Add yum repo
$ cat <<EOF | sudo tee /etc/zypp/repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/repodata/repomd.xml.key
EOF
$ sudo zypper update
# Prompt to trust or reject repo key
# ???
$ sudo zypper install -y kubelet kubeadm kubectl cri-tools kubernetes-cni --disableexcludes=kubernetes
$ systemctl enable --now kubelet
$ go install sigs.k8s.io/kind@v0.27.0
$ sudo mv ~/go/bin/kind /bin
$ sudo rm -r ~/go
$ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
$ sudo rpm -Uvh minikube-latest.x86_64.rpm
```

# RHEL and SUSE complete

------------------------

# MacOS
# Only kubectl so far
$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl"
$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl.sha256"
$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl.sha256"
$ echo "$(cat kubectl.sha256)  kubectl" | shasum -a 256 --check
$ chmod +x ./kubectl
$ sudo mv ./kubectl /usr/local/bin/kubectl
$ sudo chown root: /usr/local/bin/kubectl
$ kubectl verion --client --output=yaml
$ rm kubectl.sha256

---

# Windows
(Use curl)

KUBERNETES
1. Download the latest release with the command:
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
2.  Checksum
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
   
3. Validate
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

4. Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

5. Test to ensure the version you installed is up-to-date:
kubectl version –-client
or
kubectl version --client –-output=yaml

6. Install GO
golang.org/dl/>copy link location
wget url
ll
tar -xzvf <file>
./go/bin/go
sudo mv go /usr/local/
ll /usr/local
vi ~/.bashrc

# Add go to path
export PATH=$PATH:/usr/local/go/bin

source ~/.bash.rc

7. Install kind
/** Kind is well-suited for CI/CD environments **/
go install sigs.k8s.io/kind@v0.26.0

8. Install minikube
/** single node/ better for testing applications in a production-like environment **/
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

9. Install Helm
# Download desired version
https://github.com/helm/helm/releases
tar -zxvf helm-v3.0.0-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm

/** commenting out section for better placement **/
#Initialize a Helm repo
helm repo add bitnami https://charts.bitnami.com/bitnami

# Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
/** Now, vscode>kubernetes ext>Helm repos dropdown will display Bitnami and kubernetes-dashboard **/
# Add kubernetes-dashboard repository
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
bitnami/
/**                                            **/


# create your cluster-<cluster-name>-config.yml
/** create yaml file (vim/nano or vscode>create new file
ESPECIALLY handy when trying to create more than one node **/

kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
  - role: worker
  - role: worker

kubeadmConfigPatches:
- |
  apiVersion: kubelet.config.k8s.io/v1beta1
  kind: KubeletConfiguration
  evictionHard:
    nodefs.available: "0%"

  group: kubeadm.k8s.io
  version: v1beta3
  kind: ClusterConfiguration
  patch: |
    - op: add
      path: /apiServer/certSANs/-
      value: my-hostname

# Add dashboards to cluster
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
# Grafana :3000
# Prometheus :9090
# Strelka :9980

  