---
title: Modern, scalable systems
---

# Outline
![](https://1drv.ms/i/c/1768df040b33e7f0/IQBIDpPfeJaKT7ATKzqGYA7UAVZ8ZawCLHbAflSJUR5HHN8)
A comprehensive overview of engineering roles, responsibilities, tech stack, and best practices for building modern, scalable systems.

Use Enterprise Linux setup [script](https://github.com/ophelialabs/jb./blob/main/02_learn(iseek)/CSC/development/02_linux/setup/scripts/el9_setup1.sh)

Will update for WSL && VM

---

## AWS
### Core E-commerce
- [Retail Demo Store](https://github.com/aws-samples/retail-demo-store): This is the definitive AWS retail flagship project. It is a complete e-commerce web application used for workshops. It demonstrates personalized search via Amazon OpenSearch, recommendations using Amazon Personalize, and customer engagement via Amazon Pinpoint.
- [Retail Store Sample App](https://github.com/aws-containers/retail-store-sample-app/blob/main/README.md): A sample retail application specifically optimized for container orchestration. It provides a mock storefront, product catalog, and shopping cart. The architecture displays how to run microservices across Docker Compose or Kubernetes.
- [Bookstore Demo App](https://github.com/aws-samples/aws-bookstore-demo-app): A storefront application that showcases how to use purpose-built databases. It uses Amazon DynamoDB for the cart, OpenSearch for full-text search, Amazon Neptune for social recommendations, and Redis for leaderboards.

### AI & Intelligent Assistants
- [AI Retail Assistant](https://github.com/aws-samples/ai-retail-assistant): A project leveraging the Amazon Reviews fashion dataset. It uses Claude 3 models on Amazon Bedrock to pick product images, answer user queries via Retrieval Augmented Generation (RAG), and perform sentiment analysis.
- [Intelligent Shopping Assistant](https://github.com/aws-samples/intelligent-shopping-assistant): An advanced code sample focusing on customer assistance workflows. It integrates Amazon Bedrock, Lambda, DynamoDB, OpenSearch Service, and Amazon Personalize to build conversational retail flows.
- [Sample Retail Hybrid Search](https://github.com/aws-samples/intelligent-shopping-assistant): A repository demonstrating how retailers can build text and image product searches. It connects Amazon OpenSearch to Amazon Titan Multimodal Embeddings via Amazon Bedrock.

### Microservices & Specific Features
- [Serverless Shopping Cart Microservice](https://github.com/aws-samples/aws-serverless-shopping-cart): A isolated component repository demonstrating a decoupled checkout architecture. It runs completely serverless using Amazon API Gateway, AWS Lambda, Amazon Cognito, and Amazon DynamoDB with a Vue.js frontend.
- [Fast Secure E-Commerce Demo](https://github.com/aws-samples/fast-secure-ecommerce-demo): An architecture sample highlighting web performance and optimization. It contains a Next.js Server Side Rendered application on EC2 instances behind an ALB, with automated image manipulation using AWS Lambda.

## GCP
### Core E-Commerce
- [Online Boutique](https://github.com/googlecloudplatform/microservices-demo): Google's primary cloud-first e-commerce simulation. It contains 11 microservices written in different languages (Go, C#, Node.js) communicating via gRPC. It helps developers learn how to deploy a full shopping cart, catalog, and checkout flow on Google Kubernetes Engine (GKE).
- [Cymbal Superstore](https://github.com/GoogleCloudPlatform/cymbal-superstore): This repository showcases a modern retail application tailored for AI-assisted development on Google Cloud.

### Data Models & Analytics Workshops
- [Retail Data Model](https://github.com/GoogleCloudPlatform/retail-data-model): This repository offers standardized definitions to adapt the ARTS Operational Data Model for cloud-native infrastructure.
- [Data-to-AI Workshop](https://github.com/GoogleCloudPlatform/retail-data-to-ai-workshop): Acts as an end-to-end developer guide for processing retail data streams and building predictive models.
 
 ### AI & Merchant API Integration
 - **Retail Recommendation Systems**: Google provides specialized Jupyter notebooks, such as the Gemini Retail Use Cases, to show developers how to build multimodal recommendation tools out-of-the-box.
 - **Content API for Shopping**: The [googleads/googleads-shopping-samples](https://github.com/googleads/googleads-shopping-samples) repository contains functional code patterns to sync merchant product feeds directly with Google Shopping engines.

## Target Open Source

- [TGT Github](https://github.com/target)
| [Open Source](https://opensource.target.com)
| [TGT Tech](https://tech.target.com/open-source)
| [TGT CFC](https://opensource.target.com/security)
| [Possum](https://github.com/target/POSSUM)
| [MyTime](https://hardware.mytime.com/)
| [C2 Services](https://kb.synology.com/en-us/C2)

---

## Frontend & UI
- **Tech Focus:** [React.js](https://react.dev/), [HTML5](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/HTML5), [CSS3](https://developer.mozilla.org/en-US/docs/Web/CSS), [JavaScript (ES6+)](https://developer.mozilla.org/en-US/docs/Web/JavaScript), Micro Frontend Architecture.

- **State Management & Build Tools:** [Redux](https://redux.js.org/), [Webpack](https://webpack.js.org/), [Babel](https://babeljs.io/).

- **Getting Started: (IN PROGRESS**)**
    1. Clone the repo: `git clone https://github.com/jlabclouds/outline.git` **
    2. Install dependencies: `npm install` **
    3. Start development server: `npm start` **
    4. Explore micro frontend modules under `/src/microfrontends` **
    5. See [React Docs](https://react.dev/) for component patterns

---

To integrate a scheduling system that aligns with the TimeGo app, you can follow these steps:

### 1. **Backend API for Scheduling**

    - Create a backend API to manage schedules. This API should handle:
      - Adding, updating, and deleting shifts.
      - Fetching shifts for a specific user.
      - Handling time-off requests.
    - Example API endpoints:
      - `GET /api/schedule` - Fetch upcoming shifts.
      - `POST /api/schedule` - Add a new shift.
      - `PUT /api/schedule/:id` - Update a shift.
      - `DELETE /api/schedule/:id` - Delete a shift.

### 2. **Database Design**

    - Use a database to store scheduling data. Example schema:
      - **Shifts Table**:
         - `id`: Unique identifier.
         - `user_id`: ID of the user assigned to the shift.
         - `date`: Date of the shift.
         - `time`: Time of the shift.
         - `role`: Role for the shift.
      - **TimeOffRequests Table**:
         - `id`: Unique identifier.
         - `user_id`: ID of the user requesting time off.
         - `start_date`: Start date of the time off.
         - `end_date`: End date of the time off.
         - `status`: Status of the request (e.g., pending, approved, denied).

### 3. **Frontend Integration**

    - Update the `fetchSchedule` function to interact with the backend API.
    - Add forms for users to request time off or add shifts.
    - Example for requesting time off:
      ```html
      <div class="card">
            <h2>Request Time Off</h2>
            <form id="timeOffForm">
                 <label for="startDate">Start Date:</label>
                 <input type="date" id="startDate" name="startDate" required>
                 <label for="endDate">End Date:</label>
                 <input type="date" id="endDate" name="endDate" required>
                 <button type="submit" class="button">Submit Request</button>
            </form>
      </div>
      <script>
            document.getElementById('timeOffForm').addEventListener('submit', async (event) => {
                 event.preventDefault();
                 const startDate = document.getElementById('startDate').value;
                 const endDate = document.getElementById('endDate').value;
                 try {
                      const response = await fetch('/api/timeoff', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({ startDate, endDate })
                      });
                      if (!response.ok) throw new Error('Failed to submit request');
                      alert('Time off request submitted successfully!');
                 } catch (error) {
                      console.error(error);
                      alert('Error submitting time off request.');
                 }
            });
      </script>
      ```

### 4. Real-Time Updates
  - Use WebSockets or polling to provide real-time updates for schedule changes or notifications.

### 5. Authentication
  - Ensure the scheduling system is secure by implementing user authentication and role-based access control.

### 6. Mobile-Friendly Design
  - Ensure the UI is responsive and works well on mobile devices, aligning with the MyTimeGo app's design.

By implementing these steps, you can create a robust scheduling system that integrates seamlessly with the MyTimeGo app.


## Cart & Checkout
- [Google Pay](https://github.com/google-pay/react-store): Provides a complete reference implementation of a digital storefront built with React, designed specifically to showcase how to integrate and handle the Google Pay API in a web environment.
 
- **Scope:** 
  - Online, brick-and-mortar, Delivery, Google Express; **critical impact on guest experience**

| **Languages** | **Frameworks** | **Databases** | **Events** |
| ------------- | -------------- | ------------- | ---------- |
| [Kotlin](https://kotlinlang.org/) | [Micronaut](https://micronaut.io/) | [Postgres](https://www.postgresql.org/) | [Kafka](https://kafka.apache.org/) |
| [Groovy](https://groovy-lang.org/) | [Ratpack](https://ratpack.io/) | [Cassandra](https://cassandra.apache.org/) | |
| [JAM](https://lets-jam.org/docs/jam/index.html) | | | |

**Architecture:** Microservices, multi-tenant

- **Deployment Steps:**
    1. **Build Service Module**
    ```bash
    ./gradlew build
    ```
    2. **Run Database Migrations**
    ```bash
    flyway migrate
    ```
    3. Deploy via CI/CD (see [CI/CD & DevOps](#cicd--devops))
    4. Monitor events with [Kafka dashboard](https://grafana.com/grafana/dashboards/18276-kafka-dashboard/)

**Example: [Kotlin](https://kotlinlang.org/docs/home.html) Service Endpoint**
```kotlin
@Get("/cart")
fun getCart(): HttpResponse<Cart> = HttpResponse.ok(cartService.fetchCart())
```

---

## Engineering Roles

### Lead Java Developer

- **Experience:** [Java/J2EE](https://www.oracle.com/java/technologies/appmodel.html), [Kotlin](https://kotlinlang.org/docs/home.html), SQL/NoSQL (RDBMS: [SQL Server](https://www.microsoft.com/en-us/sql-server), [OCI DB](https://www.oracle.com/database/))([Postgres](https://www.postgresql.org/), [MongoDB](https://www.mongodb.com/), [Cassandra](https://cassandra.apache.org/_/index.html), [Graph DB](https://graphdb.ontotext.com/)), Python, Ruby, [Chef](https://www.chef.io/), [Drone](https://drone.io/), [Kubernetes containers](https://kubernetes.io/docs/concepts/containers/), Cloud tech.
  
**Lifecycle:** At least one full-cycle implementation of a major project.
 - DB Browser for SQLite
 | SQL Server

### Lead Engineer

- **Responsibilities:**
    - [Envoy](https://www.envoyproxy.io/) & [HAProxy](https://www.haproxy.org/) API Gateway management
    - Sidecar Proxy Dev-in house written in [GO](https://pkg.go.dev/github.com/googlecloudplatform/pgadapter/samples/sidecar-proxy)
    - Server Fleet Management: [Ansible](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.6)
    - Control Plane: [Go](https://github.com/envoyproxy/go-control-plane), Kafka, Redis/MongoDB
    - CDN Strategy & Migration: [Akamai](https://www.akamai.com/), [Fastly](https://www.fastly.com/)
    - API Monitoring & Security: Implement solutions/tools
- **Focus:** API gateways and microservice Kubernetes architectures, JVM-based services, high observability.

**Example: API Gateway Config (Envoy)**
```yaml
static_resources:
  listeners:
  - name: listener_0
    address:
      socket_address: { address: 0.0.0.0, port_value: 8080 }
    filter_chains:
    - filters:
      - name: envoy.filters.network.http_connection_manager
```

### Lead Engineer - Backend

- **Responsibilities:**
    - [Featurestore](https://jfrog.com/blog/what-is-a-feature-store-in-ml-and-do-i-need-one/), [Model ops](https://www.modelop.com/ai-governance-software), experimentation, monitoring, explainability, continuous improvement
    - GCP, [MLOps](https://cloud.google.com/architecture/mlops-continuous-delivery-and-automation-pipelines-in-machine-learning), scalable APIs, [ML pipelines](https://developers.google.com/machine-learning/managing-ml-projects/pipelines)
    - Deploy and monitor ML models in production

### Lead Engineer - Fullstack

- **Responsibilities:**
    - Lead [scrum teams](https://www.atlassian.com/agile/scrum)
    - [Java](https://www.java.com/), [Kotlin](https://kotlinlang.org/docs/home.html), React, [Spring Boot](https://spring.io/projects/spring-boot)/[Micronaut](https://micronaut.io/)
    - [Run SpringBoot as Micronaut](https://guides.micronaut.io/latest/micronaut-spring-boot-maven-java.html)
    - Build highly scalable distributed systems
    - Deep knowledge of domain and product features

---

## Tech Stack

- **Languages & Frameworks:** [Kotlin](https://kotlinlang.org/docs/home.html), [Java](https://www.oracle.com/java/technologies/appmodel.html), [Groovy](https://groovy-lang.org/), [Spring Boot](https://spring.io/projects/spring-boot), [Micronaut](https://micronaut.io/), [http4k](https://www.http4k.org/), [KTOR](https://ktor.io/), [Gradle](https://gradle.org/), JavaScript, TypeScript, ReactJS, [Junit](https://junit.org/), [Spock](https://github.com/spockframework/spock), [KotlinTest](https://kotlinlang.org/api/core/kotlin-test/)
- **Event Streaming:** [Kafka](https://www.confluent.io/learn/event-streaming/#when-to-use-event-streaming-vs-batch-processing), [GCP](https://cloud.google.com/products/managed-service-for-apache-kafka?hl=en)
- **Databases:** Postgres, Cassandra, MongoDB, RocksDB, InfluxDB, ELK Stack, Exadata
- **ML & Data:** [Vertex AI](https://cloud.google.com/vertex-ai), [BigQueryML](https://www.cloudskillsboost.google/course_templates/626), [Kubeflow](https://cloud.google.com/discover/what-is-kubeflow?hl=en), [Cloud Composer](https://cloud.google.com/composer), [FastAPI](https://fastapi.tiangolo.com/), Flask: [VS](https://learn.microsoft.com/en-us/visualstudio/python/learn-flask-visual-studio-step-01-project-solution?view=vs-2022), [Jinja-VS](), [VSC](https://code.visualstudio.com/docs/python/tutorial-flask), [Flask](https://palletsprojects.com/)

**Example: Spring Boot Application**
```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

---

## CI/CD & DevOps
[Strelka UI](https://github.com/target/strelka-ui?tab=readme-ov-file)
| [Vela CI/CD](https://go-vela.github.io/docs/installation/install-vela)
| [Grafana](https://grafana.com/) (Observability Dashboards)
- **Code Pipelines:** Docker, Drone, [Vela](https://github.com/go-vela/vela), [JFrog](https://jfrog.com)
- **DevOps Tools:** Jenkins, Git, Kubernetes
- **Steps:**
    1. Push code to repo
    2. Automated build/test via CI pipeline
    3. Container deploy to Kubernetes
    4. Monitoring via dashboards (see below)
 
**Example: Drone CI Pipeline**
```yaml
pipeline:
  build:
    image: gradle:latest
    commands:
      - ./gradlew build
```

---

## Metrics & Visualizations

- **Dashboards:** [Grafana](https://grafana.com/)
- **Log Aggregation:** Logstash, Kibana
- **Steps:**
    1. Set up Grafana dashboard
       - Connect to data sources for metrics.
    2. Aggregate logs with Logstash & Kibana (ELK Stack).
       - [ELK Stack](https://www.elastic.co/what-is/elk-stack)
    4. Monitor system health and alerting
       - Configure alerting rules.

**Example: Grafana Dashboard JSON**
```json
{
  "dashboard": {
    "title": "System Metrics",
    "panels": [{ "type": "graph", "targets": [{ "expr": "cpu_usage" }] }]
  }
}
```

---

## Cloud & Compute Platforms

- **Cloud:** [Google Cloud Platform (GCP)](https://cloud.google.com/)
- **Elastic Compute:** [Kubernetes](https://kubernetes.io/)

**Example: Kubernetes Deployment**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: app
        image: my-app:latest
```

---

## Best Practices & Culture

- **Values:** Diversity, inclusion, collaboration
- **Architecture:** Distributed microservices, Kubernetes, event-based (Kafka), CI/CD pipelines
- **Automation:** Everything-as-code, operational excellence, canary/A/B testing, high observability/logs/metrics
- **Approach:** Proactive issue triage, edge computing, elastic infrastructure, agile ceremonies
- **Learning:** Experiment with new tech, continuous improvement

**Example: Canary Deployment Annotation**
```yaml
metadata:
  annotations:
    deploymentstrategy: canary
```

---

## References & Useful Links

- [React Documentation](https://react.dev/)
- [Kotlin Documentation](https://kotlinlang.org/docs/home.html)
- [Spring Boot Guides](https://spring.io/guides)
- [Micronaut Guides](https://guides.micronaut.io/)
- [Kafka Introduction](https://kafka.apache.org/documentation/)
- [Kubernetes Concepts](https://kubernetes.io/docs/concepts/)
- [Google Cloud Documentation](https://cloud.google.com/docs)
- [Grafana Tutorials](https://grafana.com/tutorials/)
- [CI/CD Best Practices](https://martinfowler.com/bliki/ContinuousDelivery.html)

---

**For more details, see respective module directories and check the project wiki.**
