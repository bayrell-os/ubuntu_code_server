# Ubuntu Code Server

Visual Studio Code Server running on Ubuntu with Docker support and CUDA capability.

## 🚀 Overview

This project provides a Docker-based Visual Studio Code Server. It includes support for multiple architectures (AMD64, ARM64), CUDA for GPU acceleration, and comes pre-configured with essential development tools.

## ✨ Features

- **Visual Studio Code Server** - Access your development environment via web browser
- **Multi-architecture Support** - Works on AMD64 and ARM64 platforms
- **CUDA Support** - GPU acceleration for machine learning and data science workloads
- **Pre-installed Tools**:
  - Python, Java Node.js
  - MySQL, SQLite clients
  - Git, OpenSSH, LFTP
  - OpenResty (Nginx + Lua)
  - Supervisor for process management
- **Language Support**:
  - English (en_US)
  - Russian (ru_RU)
- **Web-based Access** - Code from anywhere via browser

## 📦 Prerequisites

- Docker installed on your system
- For CUDA support: NVIDIA GPU with appropriate drivers
- Docker Buildx for multi-architecture builds

## 🚀 Quick Start

### Pull from Docker Hub

```bash
# AMD64/ARM64 version
docker pull bayrell/ubuntu_code_server:latest-default

# CUDA version (for NVIDIA GPU)
docker pull bayrell/ubuntu_code_server:latest-cuda
```

### Run the container

```bash
# Basic run
docker run -d \
  --name code-server \
  -p 8080:8000 \
  -e CODE_SERVER_ENABLE_ADMIN=1 \
  -v ~/code-server-data:/data \
  bayrell/ubuntu_code_server:latest

# With GPU support
docker run -d \
  --name code-server \
  --gpus all \
  -p 8080:8000 \
  -e CODE_SERVER_ENABLE_ADMIN=1 \
  -v ~/code-server-data:/data \
  bayrell/ubuntu_code_server:latest-cuda
```

## 🔧 Building Images

### 1. Download Code Server binaries

```bash
./build.sh download
```

### 2. Build for different architectures

```bash
# AMD64 build
./build.sh amd64

# ARM64 build
./build.sh arm64

# CUDA build (AMD64 only)
./build.sh cuda-amd64
```

## 🐳 Running the Container

### Basic Docker Run

```bash
docker run -d \
  --name code-server \
  -p 8080:8000 \
  -v /path/to/data:/data \
  -e WWW_UID=1000 \
  -e WWW_GID=1000 \
  -e CODE_SERVER_ENABLE_ADMIN=1 \
  bayrell/ubuntu_code_server:latest-default
```

### Docker Compose

```yaml
version: '3.8'

services:
  code-server:
    image: bayrell/ubuntu_code_server:latest-default
    container_name: code-server
    ports:
      - "8080:8000"
    volumes:
      - ./data:/data
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      - WWW_UID=1000
      - WWW_GID=1000
      - CODE_SERVER_ENABLE_ADMIN=1
    restart: unless-stopped
```

### With GPU Support

```yaml
services:
  code-server:
    image: bayrell/ubuntu_code_server:latest-cuda
    container_name: code-server
    ports:
      - "8080:8000"
    volumes:
      - ./data:/data
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      - WWW_UID=1000
      - WWW_GID=1000
      - CODE_SERVER_ENABLE_ADMIN=1
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

## ⚙️ Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `WWW_UID` | 1000 | User ID for the www-data user |
| `WWW_GID` | 1000 | Group ID for the www-data user |
| `CODE_SERVER_ENABLE_ADMIN` | 0 | Enable admin mode (1 for admin) |
| `CODE_SERVER_CUDA` | 0 | Set to 1 for CUDA-enabled image |

### Ports

- **8000** - Code Server web interface

### Volumes

| Volume | Description |
|--------|-------------|
| `/data` | User data, extensions, settings |
| `/var/run/docker.sock` | Docker socket (read-only) for container management |


## 🚀 CUDA Support

### Requirements

- NVIDIA GPU with CUDA support
- NVIDIA Container Toolkit installed
- CUDA-capable drivers

### Running with CUDA

```bash
# Check GPU availability
nvidia-smi

# Run with GPU
docker run --gpus all bayrell/ubuntu_code_server:latest-cuda
```

### CUDA-Enabled Tools

- Python with GPU acceleration
- Jupyter notebooks with CUDA
- Machine learning frameworks (TensorFlow, PyTorch)


## 📄 License

This project is licensed under the terms found in the [LICENSE](LICENSE) file.


## 🔗 Links

- [Docker Hub](https://hub.docker.com/r/bayrell/ubuntu_code_server)
- [GitHub Repository](https://github.com/bayrell-os/ubuntu_code_server)
- [Code Server Official](https://coder.com/)
- [Visual Studio Code](https://code.visualstudio.com/)


## 📞 Support

For issues and questions:
- Create an issue on GitHub
- Check the troubleshooting section
- Review the Docker Hub documentation

---

**Built with ❤️ for developers**