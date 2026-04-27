#!/usr/bin/env bash
# Cloudflare Workers ビルドスクリプト
# 1-pass build (PurgeCSSは現状未使用のためシンプル構成)
set -euo pipefail

echo "🔧 [build.sh] Cloudflare Workers build start"
echo "📍 Hugo version: $(hugo version)"
echo "📍 Node version: $(node --version)"
echo "📍 npm version: $(npm --version)"

# 1) 依存解決
echo "📦 [1/2] npm ci ..."
npm ci --no-audit --no-fund

# 2) Hugo build (production)
echo "🚀 [2/2] hugo build ..."
HUGO_ENVIRONMENT=production hugo --gc --minify

echo "✅ [build.sh] build complete"
echo "📂 output: ./public"
ls -la public/ | head -20
