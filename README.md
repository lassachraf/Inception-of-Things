# 🚀 Inception of Things

<p align="center">
  <strong>42 School Project</strong><br>
  A progressive journey from virtual machines to Kubernetes and GitOps.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/42-Project-black?style=for-the-badge&logo=42" alt="42">
  <img src="https://img.shields.io/badge/Kubernetes-K3s%20%7C%20K3d-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white" alt="Kubernetes">
  <img src="https://img.shields.io/badge/Docker-Containerization-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker">
  <img src="https://img.shields.io/badge/GitOps-Argo%20CD-EF7B4D?style=for-the-badge&logo=argo&logoColor=white" alt="GitOps">
</p>

---

## 📖 About the Project

**Inception of Things (IoT)** is a 42 School project that introduces the fundamentals of **container orchestration**, **infrastructure automation**, and **GitOps**.

The project is structured as a progressive journey — each part builds on the previous one, gradually introducing new technologies and concepts until you reach a fully self-hosted GitOps pipeline.

### What You Will Learn

- 🖥️ **Virtualization** — Provisioning VMs with Vagrant
- ☸️ **Kubernetes** — Deploying and managing containerized workloads with K3s
- 🌐 **Networking** — Private networks, services, and ingress routing
- 🐳 **Containerization** — Running Kubernetes inside Docker with K3d
- 🔄 **GitOps** — Automating deployments with Argo CD
- 🦊 **Self-Hosting** — Running GitLab, PostgreSQL, and Redis inside a cluster

---

## 🗺️ Project Roadmap

```mermaid
flowchart LR
    A["🟢 Part 1<br/>Multi-Node K3s"] --> B["🔵 Part 2<br/>K3s + Ingress"]
    B --> C["🟣 Part 3<br/>GitOps with Argo CD"]
    C --> D["⭐ Bonus<br/>Self-Hosted GitLab"]

    style A fill:#4CAF50,color:#fff
    style B fill:#326CE5,color:#fff
    style C fill:#9C27B0,color:#fff
    style D fill:#EF7B4D,color:#fff
```

| Part | Infrastructure | Objective |
|:----:|:---------------|:----------|
| **1** | Vagrant + K3s | Multi-node Kubernetes cluster |
| **2** | Vagrant + K3s | Multiple applications with ingress routing |
| **3** | Docker + K3d + Argo CD | Local GitOps workflow |
| **Bonus** | K3d + GitLab + Argo CD | Complete self-hosted GitOps ecosystem |

---

## 🛠️ Technologies

| Category | Technologies |
|:---------|:-------------|
| **Virtualization** | Vagrant, VirtualBox |
| **Orchestration** | Kubernetes, K3s, K3d |
| **Containers** | Docker |
| **CLI & Packaging** | kubectl, Helm |
| **GitOps** | Argo CD |
| **Self-Hosting** | GitLab, PostgreSQL, Redis |
| **Web** | Nginx |

---

## 🟢 Part 1 — Multi-Node K3s Cluster

### Overview

The first part introduces Kubernetes through a lightweight **K3s cluster** running on virtual machines provisioned with **Vagrant**. Two VMs communicate over a private network: one acts as the **server** (control plane) and the other as an **agent** (worker node).

### Architecture

```mermaid
flowchart TB
    A["Host Machine"] --> B["Vagrant"]
    B --> C["VirtualBox"]

    C --> D["Server VM<br/>192.168.56.110"]
    C --> E["Worker VM<br/>192.168.56.111"]

    D --> F["K3s Server"]
    E --> G["K3s Agent"]

    F <-->|"Cluster Communication"| G

    F --> H["Kubernetes Cluster"]
    G --> H

    style D fill:#326CE5,color:#fff
    style E fill:#4CAF50,color:#fff
    style H fill:#263238,color:#fff
```

### Nodes

| Node | Hostname | IP Address | Role |
|:-----|:---------|:-----------|:-----|
| Server | `obelhamiS` | `192.168.56.110` | K3s Server |
| Worker | `obelhamiSW` | `192.168.56.111` | K3s Agent |

### How to Run

```bash
# 1. Navigate to Part 1
cd p1

# 2. Provision the virtual machines
vagrant up

# 3. Connect to the server node
vagrant ssh obelhamiS

# 4. Verify the cluster
sudo kubectl get nodes -o wide
sudo kubectl get pods -A
```

**Expected result:** A functional two-node Kubernetes cluster with one server and one worker.

---

## 🔵 Part 2 — K3s with Ingress

### Overview

Part 2 focuses on deploying **multiple web applications** on a single-node K3s cluster. Three Nginx-based applications are exposed through **Kubernetes Services**, and an **Ingress resource** routes incoming HTTP requests to the correct application based on the request hostname.

### Architecture

```mermaid
flowchart TB
    A["Host Machine"] --> B["Vagrant VM"]
    B --> C["K3s Server"]

    C --> D["Ingress Controller"]

    D -->|"app1.com"| E["Service: app1"]
    D -->|"app2.com"| F["Service: app2"]
    D -->|"Default"| G["Service: app3"]

    E --> H["App 1 Pod"]
    F --> I["App 2 Pod"]
    G --> J["App 3 Pod"]

    style C fill:#326CE5,color:#fff
    style D fill:#EF7B4D,color:#fff
```

### Routing Rules

| Application | Hostname | Destination |
|:------------|:---------|:------------|
| App 1 | `app1.com` | `app1` Service |
| App 2 | `app2.com` | `app2` Service |
| App 3 | Default route | `app3` Service |

### How to Run

```bash
# 1. Start the virtual machine
cd p2
vagrant up
```

Then add the following entries to your **host machine's** `/etc/hosts`:

```text
192.168.56.110  app1.com
192.168.56.110  app2.com
```

Test the applications:

```bash
curl http://app1.com        # <h1>Welcome to app1</h1>
curl http://app2.com        # <h1>Welcome to app2</h1>
curl http://192.168.56.110  # <h1>Welcome to app3</h1>
```

**Expected result:** Three independently deployed applications accessible through a single IP via host-based HTTP routing.

---

## 🟣 Part 3 — GitOps with K3d and Argo CD

### Overview

Part 3 introduces **GitOps** and automated application deployment. Rather than applying manifests manually, **Argo CD** continuously monitors a Git repository and synchronizes the cluster with the desired state declared in Git.

A **K3d cluster** (K3s running inside Docker) provides a lightweight local Kubernetes environment.

### GitOps Workflow

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant Git as Git Repository
    participant Argo as Argo CD
    participant K8s as Kubernetes

    Dev->>Git: Push manifest changes
    Argo->>Git: Monitor repository
    Git-->>Argo: New configuration
    Argo->>K8s: Synchronize resources
    K8s-->>Argo: Application healthy
```

### Prerequisites

- Linux environment (tested on Ubuntu)
- Internet connection
- Docker-compatible environment
- Permission to install system dependencies

### How to Run

```bash
# 1. Install dependencies (Docker, K3d, kubectl, Argo CD CLI)
cd p3/scripts
./install.sh
```

> ⚠️ **Important:** If the script adds your user to the `docker` group, **log out and log back in** before continuing. Verify with `docker ps`.

```bash
# 2. Create the cluster and configure Argo CD
./setup.sh
```

The setup script automatically:

- Creates a K3d cluster
- Installs Argo CD
- Connects Argo CD to the Git repository (`lassachraf/iot-alassiqu`)
- Configures the GitOps application and synchronization

### Accessing the Application

```
http://localhost:8888
```

### Accessing Argo CD

```bash
# Enable port forwarding
kubectl -n argocd port-forward svc/argocd-server 8080:443
```

Open **http://localhost:8080** and log in:

| Field | Value |
|:------|:------|
| Username | `admin` |
| Password | Printed by `setup.sh` |

**Expected result:** A working GitOps environment where Argo CD automatically deploys the application from a remote Git repository.

---

## ⭐ Bonus — Self-Hosted GitLab and Argo CD Pipeline

### Overview

The bonus takes GitOps to its logical conclusion: a **fully self-hosted** GitOps ecosystem. Instead of relying on an external Git host, a private **GitLab** instance runs inside the K3d cluster, backed by **PostgreSQL** and **Redis**. Argo CD monitors this internal GitLab repository and deploys the **wil-playground** application — all without touching an external service.

### Architecture

```mermaid
flowchart TB
    A["Developer"] --> B["Local GitLab"]
    B --> C["Git Repository"]

    subgraph K3D["K3d Kubernetes Cluster"]
        C --> D["Argo CD"]
        D --> E["Kubernetes Deployment"]
        E --> F["wil-playground"]

        G["GitLab"] --> H["PostgreSQL"]
        G --> I["Redis"]
    end

    A --> J["GitLab UI"]
    A --> K["Argo CD UI"]

    style K3D fill:#E8F0FE,stroke:#326CE5
    style G fill:#FC6D26,color:#fff
    style D fill:#EF7B4D,color:#fff
    style F fill:#326CE5,color:#fff
```

### Components

| Component | Role |
|:----------|:-----|
| K3d | Local Kubernetes cluster |
| Docker | Container runtime |
| Helm | Package manager for GitLab |
| GitLab | Self-hosted Git repository & DevOps platform |
| PostgreSQL | GitLab database dependency |
| Redis | GitLab cache & background jobs |
| Argo CD | GitOps continuous delivery |
| wil-playground | Application deployed through GitOps |

### How to Run

> ⚠️ **Warning:** This setup is **resource-intensive**. GitLab startup can take **15–25 minutes** depending on your machine.

```bash
cd Bonus/scripts
sudo ./install.sh
```

### Installation Workflow

```mermaid
flowchart TD
    A["Execute install.sh"] --> B["Install Dependencies"]
    B --> C["Create K3d Cluster"]
    C --> D["Deploy PostgreSQL"]
    D --> E["Deploy Redis"]
    E --> F["Install GitLab with Helm"]
    F --> G["Wait for GitLab Startup"]
    G --> H["Create GitLab Project"]
    H --> I["Push Initial Manifest"]
    I --> J["Install Argo CD"]
    J --> K["Configure Argo CD Application"]
    K --> L["Deploy wil-playground"]

    style A fill:#326CE5,color:#fff
    style F fill:#FC6D26,color:#fff
    style J fill:#EF7B4D,color:#fff
    style L fill:#4CAF50,color:#fff
```

### GitOps in Action — Updating the Application

One of the most interesting aspects of this bonus: application updates happen **entirely through Git**.

```bash
# 1. The script keeps a local copy of the repo at /tmp/iot-repo
cd /tmp/iot-repo

# 2. Edit confs/deployment.yaml and change the image tag
#    from: image: wil42/playground:v1
#    to:   image: wil42/playground:v2

# 3. Commit and push
git add .
git commit -m "Update application to v2"
git push
```

**Argo CD detects the change and automatically synchronizes the cluster.** No manual `kubectl apply` required.

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant Git as Local GitLab
    participant Argo as Argo CD
    participant K8s as Kubernetes

    Dev->>Git: Push image v2
    Argo->>Git: Detect repository change
    Git-->>Argo: Updated deployment.yaml
    Argo->>K8s: Apply new configuration
    K8s->>K8s: Update application deployment
    K8s-->>Argo: Application healthy
```

**Expected result:** A complete local GitOps pipeline — GitLab for source control, Argo CD for deployment — with no external dependencies.

---

## 📁 Project Structure

```text
Inception-of-Things/
│
├── p1/
│   ├── Vagrantfile
│   └── ...
│
├── p2/
│   ├── Vagrantfile
│   └── ...
│
├── p3/
│   ├── scripts/
│   │   ├── install.sh
│   │   └── setup.sh
│   └── ...
│
├── Bonus/
│   ├── scripts/
│   │   └── install.sh
│   └── ...
│
└── README.md
```

---

## 🧠 Learning Outcomes

| Concept | What We Learned |
|:--------|:----------------|
| Virtualization | Provisioning VMs with Vagrant |
| Kubernetes | Deploying and managing containerized workloads |
| K3s | Building lightweight Kubernetes clusters |
| K3d | Running Kubernetes clusters inside Docker |
| Networking | Private networks, services, ingress routing |
| Containerization | Running and managing containers |
| Helm | Installing and managing Kubernetes applications |
| GitOps | Managing infrastructure through Git |
| Argo CD | Automating Kubernetes deployments |
| GitLab | Self-hosting a private Git platform |

---

## 🧰 Useful Commands

<details>
<summary><b>Vagrant</b></summary>

```bash
vagrant up
vagrant halt
vagrant destroy
vagrant ssh
vagrant status
vagrant reload
```
</details>

<details>
<summary><b>Docker</b></summary>

```bash
docker ps
docker images
docker logs <container>
docker exec -it <container> sh
```
</details>

<details>
<summary><b>K3d</b></summary>

```bash
k3d cluster list
k3d cluster create <cluster-name>
k3d cluster delete <cluster-name>
```
</details>

<details>
<summary><b>Kubernetes</b></summary>

```bash
kubectl get nodes -o wide
kubectl get pods -A
kubectl get services -A
kubectl get deployments -A
kubectl get namespaces
kubectl get ingress -A
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl apply -f <manifest.yaml>
kubectl delete -f <manifest.yaml>
```
</details>

<details>
<summary><b>Argo CD</b></summary>

```bash
kubectl get pods -n argocd
kubectl get applications -n argocd
kubectl get services -n argocd
```
</details>

---

## 📚 Resources

| Technology | Documentation |
|:-----------|:--------------|
| Kubernetes | https://kubernetes.io/docs/ |
| K3s | https://docs.k3s.io/ |
| K3d | https://k3d.io/ |
| Vagrant | https://developer.hashicorp.com/vagrant/docs |
| Docker | https://docs.docker.com/ |
| Helm | https://helm.sh/docs/ |
| Argo CD | https://argo-cd.readthedocs.io/ |
| GitLab | https://docs.gitlab.com/ |
| PostgreSQL | https://www.postgresql.org/docs/ |
| Redis | https://redis.io/docs/ |

---

## 👥 Authors

| Member | GitHub |
|:-------|:-------|
| Member 1 | [@AchrafLassiqui](https://github.com/lassachraf) |
| Member 2 | [@AmineKaddouri](https://github.com/aminekaddouri) |
| Member 3 | [@OmarBelhamid](https://github.com/obelhami) |

---

<p align="center">
  <strong>42 School — Inception of Things</strong><br/>
  From Virtual Machines to Kubernetes and GitOps 🚀
</p>

<p align="center">
  Made with ❤️, teamwork, and a lot of debugging.
</p>
