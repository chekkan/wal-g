#!/bin/bash

# Smart entrypoint for WAL-G Docker container
# This script allows running both wal-g commands and arbitrary commands

set -e

# Debug: show what we received
# echo "DEBUG: Received arguments: $@" >&2
# echo "DEBUG: First argument: $1" >&2

# If no arguments provided, show wal-g help
if [ $# -eq 0 ]; then
    exec wal-g --help
fi

# If the first argument is a known wal-g command or option, run with wal-g
case "$1" in
    # WAL-G commands
    backup-push|backup-fetch|backup-list|backup-mark|backup-delete|wal-push|wal-fetch|wal-show|wal-verify|delete|daemon|st|stream-push|stream-fetch|stream-replay|oplog-push|oplog-fetch|oplog-replay|mongo-backup-push|mongo-backup-fetch|mongo-backup-list|mongo-backup-delete|catchup-push|catchup-fetch|redis-backup-push|redis-backup-fetch|redis-backup-list|redis-backup-delete|fdb-backup-push|fdb-backup-fetch|fdb-backup-list|fdb-backup-delete|sqlserver-backup-push|sqlserver-backup-fetch|sqlserver-backup-list|sqlserver-backup-delete)
        exec wal-g "$@"
        ;;
    # WAL-G options  
    --help|-h|--version|-v)
        exec wal-g "$@"
        ;;
    # If first argument looks like a wal-g command pattern (wal-g specific patterns only)
    backup*|wal*|oplog*|mongo*|redis*|fdb*|sqlserver*|stream*|catchup*|daemon|delete|st)
        exec wal-g "$@"
        ;;
    # Otherwise, execute the command as-is
    *)
        # echo "DEBUG: Executing command as-is: $@" >&2
        exec "$@"
        ;;
esac