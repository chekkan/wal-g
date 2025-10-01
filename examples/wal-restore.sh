#!/bin/bash
# WAL restore script for PostgreSQL with WAL-G
# Place this in /scripts/wal-restore.sh inside the postgres container

set -e

WAL_FILE="$1"
WAL_PATH="$2"

# Log the restore attempt
echo "$(date): Restoring WAL file: $WAL_FILE to $WAL_PATH"

# Use wal-g to restore the WAL file
if docker run --rm \
    -v "$(dirname "$WAL_PATH"):/wal" \
    -e WALG_S3_PREFIX \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_REGION \
    chekkan/wal-g:latest-pg \
    wal-fetch "$WAL_FILE" "/wal/$(basename "$WAL_PATH")"; then
    echo "$(date): Successfully restored $WAL_FILE"
    exit 0
else
    echo "$(date): Failed to restore $WAL_FILE (this may be normal if WAL file doesn't exist in backup)"
    exit 1
fi