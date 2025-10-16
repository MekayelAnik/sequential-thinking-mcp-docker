#!/bin/bash
set -ex
# Set variables first
REPO_NAME='sequential-thinking-mcp'
BASE_IMAGE=$(cat ./build_data/base-image 2>/dev/null || echo "node:alpine")
SEQUENTIAL_THINKING_VERSION=$(cat ./build_data/version 2>/dev/null || exit 1)
SEQUENTIAL_THINKING_MCP_REPO="@modelcontextprotocol/server-sequential-thinking"
SEQUENTIAL_THINKING_MCP_PKG="${SEQUENTIAL_THINKING_MCP_REPO}@${SEQUENTIAL_THINKING_VERSION}"
SUPERGATEWAY_PKG='supergateway@latest'
DOCKERFILE_NAME="Dockerfile.$REPO_NAME"

# Create a temporary file safely
TEMP_FILE=$(mktemp "${DOCKERFILE_NAME}.XXXXXX") || {
    echo "Error creating temporary file" >&2
    exit 1
}

# Check if this is a publication build
if [ -e ./build_data/publication ]; then
    # For publication builds, create a minimal Dockerfile that just tags the existing image
    {
        echo "ARG BASE_IMAGE=$BASE_IMAGE"
        echo "ARG SEQUENTIAL_THINKING_VERSION=$SEQUENTIAL_THINKING_VERSION"
        echo "FROM $BASE_IMAGE"
    } > "$TEMP_FILE"
else
    # Write the Dockerfile content to the temporary file first
    {
        echo "ARG BASE_IMAGE=$BASE_IMAGE"
        echo "ARG SEQUENTIAL_THINKING_VERSION=$SEQUENTIAL_THINKING_VERSION"
        cat << EOF
FROM $BASE_IMAGE AS build

# Author info:
LABEL org.opencontainers.image.authors="MOHAMMAD MEKAYEL ANIK <mekayel.anik@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/mekayelanik/sequential-thinking-mcp-docker"

# Copy the entrypoint script into the container and make it executable
COPY ./resources/ /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/banner.sh \
    && chmod +r /usr/local/bin/build-timestamp.txt

# Install required APK packages
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk --update-cache --no-cache add bash shadow su-exec tzdata && \
    rm -rf /var/cache/apk/*

# Check if package exists before installing with better error handling
RUN echo "Checking if package exists: ${SEQUENTIAL_THINKING_MCP_PKG}" && \
    if npm view ${SEQUENTIAL_THINKING_MCP_PKG} --json >/dev/null 2>&1; then \
        echo "Package found, installing..." && \
        npm install -g ${SEQUENTIAL_THINKING_MCP_PKG} --loglevel verbose && \
        echo "Package installed successfully"; \
    else \
        echo "ERROR: Package ${SEQUENTIAL_THINKING_MCP_PKG} not found in registry!" >&2; \
        echo "Available versions:" && \
        npm view ${SEQUENTIAL_THINKING_MCP_REPO} versions --json | tr -d '\[\],' | tr '"' '\n' | grep -v '^$' | head -10; \
        exit 1; \
    fi

# Install Supergateway
RUN echo "Installing Supergateway..." && \
    npm install -g ${SUPERGATEWAY_PKG} --loglevel verbose && \
    npm cache clean --force

# Use an ARG for the default port
ARG PORT=8005

# Add ARG for API key
ARG API_KEY=""

# Set an ENV variable from the ARG for runtime
ENV PORT=\${PORT}
ENV API_KEY=\${API_KEY}

# Health check using nc (netcat) to check if the port is open
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \\
    CMD nc -z localhost \${PORT:-8005} || exit 1

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EOF
    } > "$TEMP_FILE"
fi

# Atomically replace the target file with the temporary file
if mv -f "$TEMP_FILE" "$DOCKERFILE_NAME"; then
    echo "Dockerfile for $REPO_NAME created successfully."
else
    echo "Error: Failed to create Dockerfile for $REPO_NAME" >&2
    rm -f "$TEMP_FILE"
    exit 1
fi