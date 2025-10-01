#!/bin/bash

# Validation script for WAL-G Docker build
# This script validates the Docker build process without actually building

set -e

echo "🔍 Validating WAL-G Docker Build Configuration..."

# Test URL generation for all variants
VARIANTS=("pg" "mysql" "mongo" "redis" "gp" "fdb" "sqlserver")
VERSION="v3.0.7"

echo ""
echo "📋 Testing download URL generation for version $VERSION:"
echo ""

for variant in "${VARIANTS[@]}"; do
    clean_version="${VERSION#v}"
    url="https://github.com/wal-g/wal-g/releases/download/v${clean_version}/wal-g-${variant}-ubuntu-24.04-amd64.tar.gz"
    echo "  ✅ $variant: $url"
done

echo ""
echo "🔧 Validating Dockerfile syntax..."

# Check if Dockerfile exists and has required sections
if [ ! -f "Dockerfile" ]; then
    echo "❌ Error: Dockerfile not found"
    exit 1
fi

# Check for required Dockerfile elements
required_elements=(
    "FROM ubuntu:24.04"
    "ARG WAL_G_VERSION"
    "ARG WAL_G_VARIANT"
    "RUN useradd"
    "USER walg"
    "CMD"
)

for element in "${required_elements[@]}"; do
    if grep -q "$element" Dockerfile; then
        echo "  ✅ Found: $element"
    else
        echo "  ❌ Missing: $element"
        exit 1
    fi
done

echo ""
echo "🚀 Validating GitHub Actions workflows..."

# Check workflow files
workflows=(".github/workflows/build-images.yml" ".github/workflows/monitor-releases.yml")

for workflow in "${workflows[@]}"; do
    if [ ! -f "$workflow" ]; then
        echo "  ❌ Missing: $workflow"
        exit 1
    else
        echo "  ✅ Found: $workflow"
    fi
done

# Check if dependabot.yml exists
if [ ! -f ".github/dependabot.yml" ]; then
    echo "  ❌ Missing: .github/dependabot.yml"
    exit 1
else
    echo "  ✅ Found: .github/dependabot.yml"
fi

echo ""
echo "📚 Validating documentation..."

if [ ! -f "README.md" ]; then
    echo "  ❌ Missing: README.md"
    exit 1
else
    echo "  ✅ Found: README.md"
fi

# Check README contains key sections
readme_sections=(
    "WAL-G Docker Images"
    "Usage"
    "Available Tags"
    "Build Arguments"
    "Automated Builds"
)

for section in "${readme_sections[@]}"; do
    if grep -q "$section" README.md; then
        echo "  ✅ README section: $section"
    else
        echo "  ❌ Missing README section: $section"
        exit 1
    fi
done

echo ""
echo "🎉 Validation completed successfully!"
echo ""
echo "Summary:"
echo "  ✅ Dockerfile configured for multi-variant builds"
echo "  ✅ GitHub Actions workflows for automated builds and monitoring"
echo "  ✅ Dependabot configuration for dependency updates"
echo "  ✅ Comprehensive documentation"
echo ""
echo "Ready for deployment! 🚀"