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


  