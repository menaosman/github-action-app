#!/usr/bin/env bash
set -euo pipefail
IMAGE="${1:-local/github-action-app:test}"
PORT="${PORT:-3000}"

echo "Building image: $IMAGE"
docker build -t "$IMAGE" .

echo "Running container on port $PORT ..."
docker run --rm -p "$PORT:$PORT" -e PORT="$PORT" "$IMAGE"
