# Partially Dockerized Locally Running AI Chat System With Internet Search Capabilities

## Project Overview

This project provides a comprehensive solution for deploying an AI chat application using Docker containers. It
integrates several services including Ollama (AI model serving), Open WebUI (user interface), SearxNG (web search
integration), and others, all running in isolated Docker containers.

## Features

- **Dockerized Environment**: All services run in Docker containers for consistent deployment across different
  environments.
- **GPU Support**: Leverages NVIDIA GPUs for accelerated AI model inference.
- **Web Search Integration**: Uses SearxNG as a search engine to enable web-based queries within the chat interface.
- **Modular Design**: Services are separated into individual containers, making it easy to scale or modify components.

## System Requirements

### Hardware

- **NVIDIA GPU**: Required for optimal performance. Ensure your system has an NVIDIA GPU with proper drivers installed.
- **RAM**: Minimum 8GB RAM recommended; more may be needed depending on the AI models used.
- **Storage**: Sufficient disk space for Docker images and model data.

### Software

- **Docker**: Version 24 or higher. [DOCS](https://docs.docker.com/)
- **NVIDIA Drivers**: Ensure your system has the latest NVIDIA drivers installed.
- **CUDA Toolkit**: Required for GPU acceleration in Ollama.
- **Operating System**: Compatible with Linux, macOS and Windows.*

  (* some needs to deploy Ollama natively)

## Getting Started

### Prerequisites

1. Install Docker on your system:
    - [Docker Installation Guide](https://docs.docker.com/get-docker/)
2. Install NVIDIA drivers if you have an NVIDIA GPU:
    - [NVIDIA Driver Download](https://www.nvidia.com/Download/index.aspx)
3. Install CUDA Toolkit (optional but recommended for native Nvidia GPU acceleration):
    - [CUDA Toolkit Download](https://developer.nvidia.com/cuda-toolkit)
4. Install the NVIDIA Container Toolkit (optional but recommended for containerized Nvidia GPU acceleration):
    - [CUDA Container Toolkit Download](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

### Installation Steps

1. **Clone the Repository**
      ```bash
      git clone https://github.com/cZalyun/ai-chat-docker-bundle.git
      cd ai-chat-docker-bundle-test
      ```

2. **Set Up Environment Variables**
    - Copy the `.env.example` file to `.env`:
      ```bash
      cp .env.example .env
      ```
    - Open `.env` and adjust variables as needed (explained in the .env.example).

### Running the Application

1. **Start Services**
    - Run the provided script:
      ```bash
      ./start.sh
      ```
    - This script builds and starts all necessary Docker containers.

    - Alternatively you can run the initiation commands directly
        ```bash
        docker compose --profile containerized up -d
      ```

        ```bash
      # Partially dockerised
      docker compose up -d
      ```


2. **Accessing Services**
    - **Open WebUI**: Visit `http://localhost:3000` in your browser (.env specified
      port). [DOCS](https://openwebui.com/)
    - **Ollama API**: Accessible at `http://localhost:11434` (.env specified
      port). [DOCS](https://github.com/ollama/ollama)
    - **Search Engine UI**: Accessible at `http://localhost:8081` (.env specified
      port). [DOCS](https://docs.searxng.org/)

### Troubleshooting

- **Docker Not Running**: Ensure Docker is installed and running.
- **Port Conflicts**: Check if ports are occupied by other services.
- **GPU Issues**: Verify NVIDIA drivers and CUDA toolkit are correctly installed.
- **Environment Variables**: Double-check `.env` file for correct configurations.

## Contributing

Contributions are welcome! Please:

1. Fork the repository.
2. Create a feature branch.
3. Commit changes.
4. Push to the branch.
5. Open a Pull Request.
