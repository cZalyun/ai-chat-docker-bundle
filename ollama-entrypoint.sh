#!/bin/sh

echo "Starting Ollama..."

# Start Ollama in the background
ollama serve &

# Give Ollama some time to initialize
sleep 5

# Pull each model in parallel
if [ -n "$OLLAMA_MODEL_LIST" ]; then
    echo "Pulling models: $OLLAMA_MODEL_LIST"
    echo $OLLAMA_MODEL_LIST | tr "," "\n" | xargs -P 4 -I {} sh -c 'echo "Pulling {}..."; ollama pull {}'
fi

# Keep Ollama running in the foreground
wait
