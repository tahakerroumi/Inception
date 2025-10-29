# Inception (Docker System Administration Project)

This project aims to broaden your knowledge of system administration through the use of Docker technology. You will virtualize several Docker images by creating them in your new personal virtual machine.
<img width="3000" height="3000" alt="image" src="https://github.com/user-attachments/assets/71553ffe-6a9d-4398-96e2-df480ce545d1" />


## Let's get started

First of all let's get deeper and explain what is Docker technology.

**Docker** is an open-source platform for developing, shipping, and running applications in an isolated environment called a `container`. It enables you to separate applications from your infrastructure, ensuring quick and consistent software delivery.

### So why do we use it?

**Docker** allows developers to run applications consistently across different environments. It packages everything an app needs—code, libraries, and settings—so it works reliably on any computer, eliminating setup problems and dependency conflicts.

Before containers, applications were deployed directly on the **host system**, meaning:

- You had to install the right versions of libraries, dependencies, and runtime.
- It worked on your machine but **broke elsewhere** because of environment differences (e.g. different OS versions, missing libraries, etc.).

---

### So how Docker does that?

By **packaging everything the app needs** — code, dependencies, system libraries, and runtime — **into a single image**.

That image is then used to create **containers**.

So, a container isn't just your app — it's your app **plus**:

- Its dependencies (`libssl`, `libc`, etc.)
- Its environment (e.g. Python, Node.js, etc.)
- Its filesystem structure

You may have seen a lot of new names that we need to explain more in order to get a bigger picture on how docker works and uses to let users run dynamic application that work on different environment.

## What is a Docker Image?

To explain what a docker image is we should first know what a dockerfile is.

Dockerfile is a plain text document that contains a series of instructions used by Docker to automatically build a container image. It acts as a blueprint or a recipe, defining the steps and commands required to create a reproducible and consistent environment for an application within a Docker container.

In a Dockerfile everything on the left is **INSTRUCTION**, and on the right is an **ARGUMENT** to those instructions. Remember that the file name is `"Dockerfile"` without any extension.
<img width="454" height="200" alt="image" src="https://github.com/user-attachments/assets/bb5b6624-c5a4-4c6b-9852-acaa6f294bb7" />


### Dockerfile Instructions

The following table contains the important **Dockerfile** instructions and their explanation.

| Instruction | Description |
|-------------|-------------|
| **FROM** | To specify the base image that can be pulled from a container registry (Docker hub, GCR, Quay, ECR, etc.) |
| **RUN** | Executes commands during the image build process. |
| **ENV** | Sets environment variables inside the image. It will be available during build time as well as in a running container. If you want to set only build-time variables, use ARG instruction. |
| **COPY** | Copies local files and directories to the image |
| **EXPOSE** | Specifies the port to be exposed for the Docker container. |
| **WORKDIR** | Sets the current working directory. You can reuse this instruction in a Dockerfile to set a different working directory. If you set WORKDIR, instructions like `RUN`, `CMD`, `ADD`, `COPY`, or `ENTRYPOINT` gets executed in that directory. |
| **VOLUME** | It is used to create or mount the volume to the Docker container |
| **USER** | Sets the user name and UID when running the container. You can use this instruction to set a non-root user of the container. |
| **CMD** | It is used to execute a command in a running container. There can be only one CMD, if multiple CMDs then it only applies to the last one. It **can be overridden** from the Docker CLI. |

### Docker Image Layers

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
5. `CMD [...]` — Docker defines the **default command** and stores it as **metadata (extra information about the image)**, not a full layer.

> 💡 **Note:** If a line hasn't changed since the last build, Docker **reuses the cached layer** instead of rebuilding it — this makes builds faster.

After processing all instructions:

- Docker **combines all layers** into one **read-only image**.

So now we can say **A Docker image** is a **read-only template** that contains everything needed to run an application: code, runtime, libraries, environment variables, and configuration files.
<img width="968" height="284" alt="image" src="https://github.com/user-attachments/assets/c5d56205-fd0d-4c80-9b44-facdbf63389e" />
<img width="1606" height="1008" alt="image" src="https://github.com/user-attachments/assets/fa0e039a-cb3a-430e-a538-9fb098934e78" />


## What is a Container?

A **container** is a **lightweight, runnable instance of a Docker image**.

- It includes the application and all its dependencies, but runs **isolated from the host system**.
- Containers are **ephemeral by default**, meaning changes inside the container do not modify the original image unless explicitly committed.
- They share the host OS kernel but have **separate namespaces** for processes, filesystem, network, and more.
