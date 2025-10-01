FROM ubuntu:24.04

# Set build arguments for wal-g version and variant
ARG WAL_G_VERSION="v3.0.7"
ARG WAL_G_VARIANT="pg"

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create wal-g user
RUN useradd -r -s /bin/false walg

# Set working directory
WORKDIR /opt/wal-g

# Download and install wal-g
# Note: Using a specific version pattern since we know the format
RUN VERSION="${WAL_G_VERSION#v}" && \
    DOWNLOAD_URL="https://github.com/wal-g/wal-g/releases/download/v${VERSION}/wal-g-${WAL_G_VARIANT}-ubuntu-24.04-amd64.tar.gz" && \
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

# Set default command
CMD ["wal-g", "--help"]