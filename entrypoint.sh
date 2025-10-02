#!/bin/bash

# Simple entrypoint for WAL-G Docker container
# Inspired by clickhouse-backup approach
# If no arguments, starts with --, or is not an executable command, run with wal-g
# Otherwise execute the command directly

set -e

if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]] || [[ ! -x $(command -v "$1" 2>/dev/null) ]]; then
    exec wal-g "$@"
fi

exec "$@"