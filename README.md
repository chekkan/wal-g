# WAL-G Docker Images

This repository contains Docker images for [WAL-G](https://github.com/wal-g/wal-g), a backup tool for PostgreSQL, MySQL, MongoDB, Redis, and other databases.

## Features

- 🚀 **Automated Builds**: Automatically builds new Docker images when WAL-G releases new versions
- 🔄 **Multiple Variants**: Supports all WAL-G database variants (PostgreSQL, MySQL, MongoDB, Redis, Greenplum, FDB, SQL Server)
- 🛡️ **Security**: Runs as non-root user, uses distroless base images
- 📦 **GitHub Container Registry**: Images are published to `ghcr.io/chekkan/wal-g`
- 🤖 **Dependabot**: Automatically updates dependencies

## Usage

### Pull the latest image

```bash
# PostgreSQL variant (default)
docker pull ghcr.io/chekkan/wal-g:latest-pg

# MySQL variant
docker pull ghcr.io/chekkan/wal-g:latest-mysql

# MongoDB variant
docker pull ghcr.io/chekkan/wal-g:latest-mongo

# Redis variant
docker pull ghcr.io/chekkan/wal-g:latest-redis
```

### Run WAL-G

```bash
# Show help
docker run --rm ghcr.io/chekkan/wal-g:latest-pg

# Run with your configuration
docker run --rm \
  -e WALG_S3_PREFIX="s3://your-bucket/path" \
  -e AWS_ACCESS_KEY_ID="your-access-key" \
  -e AWS_SECRET_ACCESS_KEY="your-secret-key" \
  -v /var/lib/postgresql/data:/var/lib/postgresql/data \
  ghcr.io/chekkan/wal-g:latest-pg \
  backup-push /var/lib/postgresql/data
```

### Available Tags

- `latest` - Latest PostgreSQL variant
- `latest-pg` - Latest PostgreSQL variant
- `latest-mysql` - Latest MySQL variant  
- `latest-mongo` - Latest MongoDB variant
- `latest-redis` - Latest Redis variant
- `latest-gp` - Latest Greenplum variant
- `latest-fdb` - Latest FoundationDB variant
- `latest-sqlserver` - Latest SQL Server variant
- `v3.0.7` - Specific version (PostgreSQL variant)
- `v3.0.7-mysql` - Specific version with variant

## Build Arguments

The Dockerfile supports the following build arguments:

- `WAL_G_VERSION`: Version of WAL-G to install (default: "latest")
- `WAL_G_VARIANT`: Database variant to install (default: "pg")

### Available Variants

- `pg` - PostgreSQL
- `mysql` - MySQL/MariaDB
- `mongo` - MongoDB
- `redis` - Redis
- `gp` - Greenplum
- `fdb` - FoundationDB
- `sqlserver` - SQL Server

## Automated Builds

This repository automatically:

1. ✅ Monitors the [wal-g/wal-g](https://github.com/wal-g/wal-g) repository for new releases
2. ✅ Skips pre-releases (only builds stable releases)
3. ✅ Builds Docker images for all supported database variants
4. ✅ Publishes images to GitHub Container Registry
5. ✅ Creates git tags matching WAL-G versions

## Development

### Manual Build

```bash
# Build locally
docker build -t wal-g:local .

# Build specific variant
docker build --build-arg WAL_G_VARIANT=mysql -t wal-g:mysql .

# Build specific version
docker build --build-arg WAL_G_VERSION=v3.0.7 -t wal-g:v3.0.7 .
```

### Trigger Manual Build

You can manually trigger a build via GitHub Actions:

1. Go to the "Actions" tab
2. Select "Build WAL-G Docker Images"
3. Click "Run workflow"
4. Optionally specify a WAL-G version

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Related Projects

- [WAL-G](https://github.com/wal-g/wal-g) - The backup tool this project packages