# Inception

> A comprehensive guide to understanding Docker and containerization technology through system administration 

<img width="1196" height="704" alt="image" src="https://github.com/user-attachments/assets/6a81cbe2-cd24-4450-8ca0-32666a9a62a9" />




## 📋 Table of Contents

- [Let's get started](#lets-get-started)
- [What is Docker?](#what-is-docker)
- [Why do we use it?](#so-why-do-we-use-it)
- [How Docker does that?](#so-how-docker-does-that)
- [Docker Images](#what-is-a-docker-image)
- [Docker Containers](#now-what-is-a-container)
- [Core Components of Docker](#-the-core-components-of-docker)
- [Docker Volumes](#1-docker-volumes--persistent-data-storage)
- [Docker Networks](#-2-docker-networks--container-communication)
- [Docker Compose](#-docker-compose--overview)
- [Resources](#-resources)
- [Contributing](#-contributing)

---

# Let's get started :

first of all let's get deeper and explain what is Docker technology.

**Docker** is an open-source platform for developing, shipping, and running applications in an isolated environment called a `container`. It enables you to separate applications from your infrastructure, ensuring quick and consistent software delivery.

### *so why do we use it?*

**Docker** allows developers to run applications consistently across different environments. It packages everything an app needs—code, libraries, and settings—so it works reliably on any computer, eliminating setup problems and dependency conflicts.

Before containers, applications were deployed directly on the **host system**, meaning:

- You had to install the right versions of libraries, dependencies, and runtime.
- It worked on your machine but **broke elsewhere** because of environment differences (e.g. different OS versions, missing libraries, etc.).

---

### so how Docker does that?

by **packaging everything the app needs** — code, dependencies, system libraries, and runtime — **into a single image**.

That image is then used to create **containers**.

So, a container isn't just your app — it's your app **plus**:

- Its dependencies (`libssl`, `libc`, etc.)
- Its environment (e.g. Python, Node.js, etc.)
- Its filesystem structure

you may have seen a lot of new names that we need to explain more in order o get a bigger picture on how docker works and uses to let users run dynamic application that work on different environment.

**what is a Docker Image?**

to explain what a docker image is we should first know what a dockerfile is,

Dockerfile is a plain text document that contains a series of instructions used by Docker to automatically build a container image. It acts as a blueprint or a recipe, defining the steps and commands required to create a reproducible and consistent environment for an application within a Docker container.

In a Dockerfile everything on the left is **INSTRUCTION**, and on the right is an **ARGUMENT** to those instructions. Remember that the file name is `"Dockerfile"` without any extension.

<img width="454" height="200" alt="image" src="https://github.com/user-attachments/assets/0539eb9f-1670-4233-9d72-9c193c7107cc" />


The following table contains the important **Dockerfile** instructions and their explanation.

#### Dockerfile Instructions

| Instruction | Description |
|-------------|-------------|
| `FROM` | To specify the base image that can be pulled from a container registry (Docker hub, GCR, Quay, ECR, etc.) |
| `RUN` | Executes commands during the image build process. |
| `ENV` | Sets environment variables inside the image. It will be available during build time as well as in a running container. If you want to set only build-time variables, use ARG instruction. |
| `COPY` | Copies local files and directories to the image |
| `EXPOSE` | Specifies the port to be exposed for the Docker container. |
| `WORKDIR` | Sets the current working directory. You can reuse this instruction in a Dockerfile to set a different working directory. If you set WORKDIR, instructions like `RUN`, `CMD`, `ADD`, `COPY`, or `ENTRYPOINT` gets executed in that directory. |
| `VOLUME` | It is used to create or mount the volume to the Docker container |
| `USER` | Sets the user name and UID when running the container. You can use this instruction to set a non-root user of the container. |
| `CMD` | It is used to execute a command in a running container. There can be only one CMD, if multiple CMDs then it only applies to the last one. It **can be overridden** from the Docker CLI. |

**Dockerfile** builds an image in **layers**, where each instruction adds a new layer on top of the previous one. These layers are **stacked and cached**, which makes Docker images efficient and fast to build.

Layers let you extend images of others by reusing their base layers, allowing you to add only the data that your application needs.

Example:

```dockerfile
FROM ubuntu:22.04        # Layer 1
RUN apt-get update       # Layer 2
RUN apt-get install -y python3  # Layer 3
COPY . /app              # Layer 4
CMD ["python3", "app.py"]# Layer 5 (metadata only)
```

1. `FROM ubuntu:22.04` — Docker pulls the **base image** and uses it as the **first layer**.
2. `RUN apt-get update` — Docker runs this command in a **temporary container**, commits the result, and saves it as a **new layer**.
3. `RUN apt-get install -y python3` — Docker runs another container on top of the previous layer, commits it, and creates another **layer**.
4. `COPY . /app` — Docker copies files from your host into the container's filesystem, creating a **new layer**.
5. `CMD [...]` — Docker defines the **default command** and stores it as **metadata(extra information about the image)**, not a full layer.

> 💡 If a line hasn't changed since the last build, Docker **reuses the cached layer** instead of rebuilding it — this makes builds faster.

After processing all instructions:
- Docker **combines all layers** into one **read-only image**.

So now we can say **A Docker image** is a **read-only template** that contains everything needed to run an application: code, runtime, libraries, environment variables, and configuration files.

<img width="468" height="250" alt="image" src="https://github.com/user-attachments/assets/98d25238-65a9-4778-87f6-f0c678f0841e" /> <img width="560" height="700" alt="image" src="https://github.com/user-attachments/assets/86c3b7fe-2279-4493-9d07-9bf06f9854d2" />



---

### now what is a container?

A **container** is a **lightweight, runnable instance of a Docker image**.

- It includes the application and all its dependencies, but runs **isolated from the host system**.
- Containers are **ephemeral by default**, meaning changes inside the container do not modify the original image unless explicitly committed.
- They share the host OS kernel but have **separate namespaces** for processes, filesystem, network, and more.

✅ **How Docker runs containers:**

- **Creates a writable layer** on top of the image (the *container layer*).
    
    → This is where runtime changes happen (files you write, logs, etc.).
    
- **Sets up namespaces & cgroups** to isolate the container's environment:
    - **PID namespace** → gives the container its own process tree
    - **Network namespace** → isolated virtual network (with virtual Ethernet)
    - **Mount namespace** → gives its own filesystem view (based on the image)
    - **UTS / IPC namespaces** → separate hostname and interprocess communication
    - **cgroups** → limit CPU, RAM, etc. usage
- **Creates a process** using the container's writable + read-only filesystem layers.
- **Executes the command** defined in `CMD` or `ENTRYPOINT` inside that isolated environment.

now that we explain what image, container and dockerfiles are, now lets deep dive into how docker works under the hood:

---

## 🧩 The Core Components of Docker

### 1. **Docker CLI (`docker`)**

- The **command-line tool** you use (e.g., `docker run`, `docker build`, `docker ps`).
- It doesn't run containers directly.
    
    It just sends requests (via REST API) to the **Docker daemon (`dockerd`)**.
    

---

### 2. **Docker Daemon (`dockerd`)**

- This is the **main background service** that does all the heavy work.
- It:
    - Builds images (from Dockerfiles)
    - Manages images, networks, and volumes
    - Creates and manages containers
- It **communicates with lower-level runtimes** (like `containerd` and `runc`).

🧠 Think of `dockerd` as **Docker's brain** — it receives commands from the CLI and delegates work to other components.

---

### 3. **Containerd**

- `containerd` is a **container runtime daemon** — it's responsible for:
    - Managing container lifecycles (create, start, stop, delete)
    - Pulling and pushing images
    - Managing snapshots (container layers)
    - Talking to lower runtimes like `runc`

⚙️ `dockerd` uses `containerd` as an **intermediary** to handle the actual container management.

So, when you do `docker run`, `dockerd` calls the **containerd API** to start a container.

---

### 4. **runc**

- `runc` is the **low-level container runtime** (defined by the **Open Container Initiative — OCI**).
- It's what **actually creates the Linux container**:
    - Uses **namespaces** and **cgroups** (in the Linux kernel) to isolate the process.
    - Mounts the container's **root filesystem** (from the image layers).
    - Starts the process (like `/bin/bash` or your `CMD`).

🧠 You can think of `runc` as the **hands** — it's the program that directly calls the Linux kernel to isolate and start containers.

<img width="2000" height="1256" alt="image" src="https://github.com/user-attachments/assets/2f2834fa-1c6b-46f7-80bc-269333c73739" />
<img width="2567" height="1491" alt="image" src="https://github.com/user-attachments/assets/8a5311b1-d19e-4da4-b37d-ca8d1076aa05" />


So to summarize:

> Docker is not one program.
> 
> 
> It's a stack of layers where each component has its job —
> 
> the CLI talks to the daemon, the daemon uses `containerd`,
> 
> and `containerd` uses `runc` to create real containers via Linux kernel features.
> 

now let's dive into 2 key concepts when running containers:

---

## **1. Docker Volumes — Persistent Data Storage**

### 🧠 The problem:

By default, a container's writable layer is **ephemeral** — it disappears when the container is removed.

If you write files inside a container (e.g., database data, logs), they are lost when the container stops.

### 💾 The solution: **Volumes**

A **Docker Volume** is **a special storage area managed by Docker**, stored **outside the container's writable layer** (on the host machine).

When you attach a volume to a container, it **mounts a real directory from the host filesystem** into the container.

**Types of Docker Volumes:**

<img width="1100" height="361" alt="image" src="https://github.com/user-attachments/assets/c3b1f632-456d-4495-a0dc-d216e63f095b" />


in this project we will use only **named volumes.**

### **Named Volumes**

Named volumes are user-defined volumes that can be easily referenced by name and reused across multiple containers. They are stored in Docker's internal volume store.

```bash
docker volume create myVolume
docker run -d --name my_container -v myVolume:/data node_container
```

**Mounting Named Volumes**

<img width="681" height="333" alt="image" src="https://github.com/user-attachments/assets/21ee3513-aa2e-48be-bd79-db985a73f715" />


To mount a named volume to a container:

```bash
docker run -d -v myVolume:/app/data myImage
```

---

## 🌐 **2. Docker Networks — Container Communication**

### 🧠 The problem:

By default, each container is isolated — it can't talk to others or the host directly.

### 🌍 The solution: **Docker Networks**

Docker provides **virtual networks** that allow containers to communicate securely.

Docker creates these networks using **Linux network namespaces** and **virtual Ethernet interfaces (veth pairs)**.

<img width="1000" height="500" alt="image" src="https://github.com/user-attachments/assets/c6120bf4-79eb-468b-bb53-f5c1e033e2f4" />

[Youtube](https://www.youtube.com/watch?v=TSrW2tapx-8)

**Last bot not least we will explain what docker-compose is:**

---

## 🧩 **Docker Compose — Overview**

**Docker Compose** is a tool for **defining and running multi-container Docker applications**.

Instead of manually running multiple `docker run` commands, you describe your entire application in a **single YAML file (`docker-compose.yml`)**, including:

- **Services** (containers)
- **Networks**
- **Volumes**
- Dependencies between containers
- Environment variables
- Ports

Then, with a single command, Docker Compose builds, creates, and starts all containers in the correct order.

When you run:

```bash
docker-compose up
```

1. **Parse YAML**: Compose reads `docker-compose.yml` and builds a service graph (dependency tree).
2. **Create Networks & Volumes**:
    - Named volumes are created if they don't exist.
    - Custom networks are created for services.
3. **Build Images** (if `build` is specified) using the Dockerfile for each service.
4. **Start Containers** in dependency order (`depends_on`) using the Docker API:
    - Compose talks to **dockerd**, which calls **containerd → runc**.
5. **Attach Containers to Networks & Volumes**:
    - Each container's namespace is configured, writable layer is added, networks attached, volumes mounted.
6. **Attach Logs & Stream Output**: Compose attaches to container stdout/stderr for all services in the CLI.

---

## 📚 Resources

- [How Docker Works](https://devopscube.com/what-is-docker/)
- [Docker Hub](https://hub.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Open Container Initiative (OCI)](https://opencontainers.org/)
- [containerd Documentation](https://containerd.io/)
- [Docker Networking](https://www.geeksforgeeks.org/devops/basics-of-docker-networking/)

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page.

---

Made with ❤️ for learning Docker
