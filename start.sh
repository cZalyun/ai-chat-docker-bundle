#!/bin/sh
# -----------------------------------------------------------------------------
# Script: start.sh
# Purpose:
#   - On macOS with an Apple GPU, install and configure Ollama (using Homebrew),
#     start the Ollama server in the background, pull specified models in parallel
#     and finally launch Docker containers.
#   - On systems without an Apple GPU (or non-macOS), simply start Docker
#     containers using the --profile containerized.
#
# Requirements:
#   - A .env file (optional) in the same directory for environment variables,
#     including OLLAMA_MODEL_LIST (a comma-separated list of models to pull).
#   - Docker and Homebrew must be installed.
#   - On macOS, this script uses system_profiler to detect Apple GPUs.
#
# Usage:start.sh
#   ./start.sh
# -----------------------------------------------------------------------------


# --- Step 1: Check if Docker is Installed and Running ---
if command -v docker >/dev/null 2>&1; then
    echo "Docker is installed."
    # Test if the Docker daemon is running by calling 'docker info'.
    docker info >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Docker daemon is not running. Attempting to start it..."
        # On macOS, start Docker Desktop; on Linux, use systemctl.
        if [ "$(uname)" = "Darwin" ]; then
            open -a Docker
        else
            sudo systemctl start docker
        fi
        echo "Waiting for Docker daemon to initialize..."
        sleep 10
    else
        echo "Docker daemon is running."
    fi
else
    echo "Docker is not installed. Please install Docker and try again."
    exit 1
fi

# --- Step 2: Check for Apple GPU on macOS ---
if [ "$(uname)" = "Darwin" ]; then
  echo "Running on macOS. Checking for Apple GPU..."
  # Check for "Chipset Model: Apple" in the display information.
  if ! system_profiler SPDisplaysDataType | grep "Chipset Model: Apple"; then
    echo "No Apple GPU found. Skipping Ollama tasks."
    echo "Starting Docker containers with '--profile containerized'..."
    docker compose --profile containerized up -d
    exit 0
  else
    echo "Apple GPU detected. Proceeding with Ollama setup."
  fi
else
  echo "Not running on macOS. Skipping Native Ollama tasks."
  echo "Starting Docker containers with '--profile containerized'..."
  docker compose --profile containerized up -d
  exit 0
fi

# --- Step 3: Ollama Setup and Environment Loading (ONLY FOR APPLE SILICON) ---
echo "Adding Ollama..."

# --- Step 4: Install Ollama and Start Its Server in the Background ---
echo "Installing Ollama via Homebrew..."
# Install Ollama and start its server in the background.
brew install ollama
brew services start ollama

# Allow Ollama some time to initialize.
echo "Waiting 5 seconds for Ollama to initialize..."
sleep 5


# --- Step 5: Load environment variables from .env if available ---
if [ -f .env ]; then
    echo "Sourcing .env file..."
    source .env
else
    echo ".env file not found; continuing without it."
fi

# --- Step 6: Pull Models in Parallel (if specified) ---
# Check if OLLAMA_MODEL_LIST is set (e.g., "deepseek-r1:1.5b,deepseek-r1:7b").
if [ -n "$OLLAMA_MODEL_LIST" ]; then
    echo "Pulling models: $OLLAMA_MODEL_LIST"
    # Replace commas with newlines and use xargs to run pulls concurrently.
    echo "$OLLAMA_MODEL_LIST" | tr ',' '\n' | xargs -P 4 -I {} sh -c 'echo "Pulling {}..."; ollama pull {}'
else
    echo "No models specified in OLLAMA_MODEL_LIST."
fi

# --- Step 7: Launch Docker Containers ---
echo "Starting Docker containers with 'docker compose up -d'..."
docker compose up -d

# -----------------------------------------------------------------------------
# End of Script
# -----------------------------------------------------------------------------
