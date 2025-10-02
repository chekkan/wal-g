FROM ubuntu:24.04

# Set build arguments for wal-g version and variant
ARG WAL_G_VERSION="v3.0.7"
ARG WAL_G_VARIANT="pg"
ARG TARGETPLATFORM

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create wal-g user
RUN useradd -r -s /bin/bash walg

# Set working directory
WORKDIR /opt/wal-g

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Download and install wal-g
# Note: Using a specific version pattern since we know the format
RUN VERSION="${WAL_G_VERSION#v}" && \
    case "${TARGETPLATFORM}" in \
        "linux/amd64") \
            UBUNTU_VERSION="24.04" && \
            ARCH="amd64" \
            ;; \
        "linux/arm64") \
            UBUNTU_VERSION="22.04" && \
            ARCH="aarch64" \
            ;; \
        *) \
            echo "Unsupported platform: ${TARGETPLATFORM}" && \
            exit 1 \
            ;; \
    esac && \
    DOWNLOAD_URL="https://github.com/wal-g/wal-g/releases/download/v${VERSION}/wal-g-${WAL_G_VARIANT}-ubuntu-${UBUNTU_VERSION}-${ARCH}.tar.gz" && \
    echo "Downloading wal-g v${VERSION} variant ${WAL_G_VARIANT} from ${DOWNLOAD_URL}" && \
    curl -L "$DOWNLOAD_URL" -o wal-g.tar.gz && \
    tar -xzf wal-g.tar.gz && \
    chmod +x wal-g-* && \
    mv wal-g-* /usr/local/bin/wal-g && \
    rm wal-g.tar.gz

# Change ownership
RUN chown -R walg:walg /opt/wal-g

# Switch to wal-g user
USER walg

# Verify installation
RUN wal-g --help

# Set entrypoint and default command
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["--help"]