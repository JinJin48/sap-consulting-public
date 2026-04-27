#!/usr/bin/env bash
# Cloudflare Workers ビルドスクリプト
# Hugo Extended 版を明示的に使用 (Doksテーマ libsass 対応のため必須)
set -euo pipefail

HUGO_VERSION="${HUGO_VERSION:-0.160.1}"

echo "🔧 [build.sh] Cloudflare Workers build start"
echo "📍 Required Hugo version: ${HUGO_VERSION} (extended)"
echo "📍 Node version: $(node --version)"
echo "📍 npm version: $(npm --version)"

# 1) Hugo Extended をダウンロード(Cloudflare のデフォルト Hugo は非Extendedのため上書き)
echo "⬇️  [1/3] Downloading Hugo Extended ${HUGO_VERSION}..."
HUGO_TARBALL="hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
HUGO_URL="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_TARBALL}"
mkdir -p /tmp/hugo-bin
curl -fsSL -o "/tmp/${HUGO_TARBALL}" "${HUGO_URL}"
tar -xzf "/tmp/${HUGO_TARBALL}" -C /tmp/hugo-bin
export PATH="/tmp/hugo-bin:${PATH}"
echo "📍 Hugo version (after install): $(hugo version)"

# 2) 依存解決
echo "📦 [2/3] npm ci ..."
npm ci --no-audit --no-fund

# 3) Hugo build (production)
echo "🚀 [3/3] hugo build ..."
HUGO_ENVIRONMENT=production hugo --gc --minify

echo "✅ [build.sh] build complete"
echo "📂 output: ./public"
ls -la public/ | head -20
