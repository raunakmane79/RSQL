#!/usr/bin/env bash
set -euo pipefail

PORT="${PORT:-3000}"
BASE_URL="http://127.0.0.1:${PORT}"

echo "Checking health endpoint..."
curl -fsS "${BASE_URL}/health" >/tmp/health-response.json
cat /tmp/health-response.json

echo "Checking publications endpoint response shape..."
HTTP_CODE=$(curl -s -o /tmp/publications-response.json -w "%{http_code}" "${BASE_URL}/api/getPublications.asp")

if [[ "$HTTP_CODE" != "200" ]]; then
  echo "Publications endpoint returned HTTP ${HTTP_CODE}."
  echo "Response body:"
  cat /tmp/publications-response.json
  exit 1
fi

if ! head -c 1 /tmp/publications-response.json | grep -q "\["; then
  echo "Expected JSON array from /api/getPublications.asp"
  cat /tmp/publications-response.json
  exit 1
fi

echo "Smoke test passed."
