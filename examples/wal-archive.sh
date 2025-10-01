#!/bin/bash
# WAL archive script for PostgreSQL with WAL-G
# Place this in /scripts/wal-archive.sh inside the postgres container

set -e

WAL_FILE="$1"
WAL_PATH="$2"

# Log the archiving attempt
echo "$(date): Archiving WAL file: $WAL_FILE from $WAL_PATH"

# Use wal-g to archive the WAL file
if docker run --rm \
    -v "$(dirname "$WAL_PATH"):/wal:ro" \
    -e WALG_S3_PREFIX \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_REGION \
    ghcr.io/chekkan/wal-g:latest-pg \
    wal-push "/wal/$(basename "$WAL_PATH")"; then
    echo "$(date): Successfully archived $WAL_FILE"
    exit 0
else
    echo "$(date): Failed to archive $WAL_FILE"
    exit 1
fi