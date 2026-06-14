#!/usr/bin/env bash
#
# Instant manual deploy.
#
# Production is PULL-based: a systemd timer on the server pulls this repo from
# GitHub every 60s (see README → Deploy). This script just skips the wait —
# it pushes the current commit, then triggers the server's sync immediately.
#
# Run from the project root:  ./deploy.sh
# Requires: the change committed & SSH access to the server (port 22 works from
# non-datacenter IPs; GitHub runners are firewalled, hence the pull model).

set -euo pipefail

SSH_HOST="root@187.124.213.14"
DOMAIN="bazmivoicechat.com"
WEBROOT="/home/bazmivoicechat/htdocs/bazmivoicechat.com"

cd "$(dirname "$0")"

if [[ -n "$(git status --porcelain)" ]]; then
  echo "✗ You have uncommitted changes. Commit them first (the server deploys committed git state)." >&2
  git status --short
  exit 1
fi

echo "→ Pushing to GitHub…"
git push origin master

echo "→ Triggering server sync (instead of waiting for the 60s timer)…"
ssh -o ConnectTimeout=20 "$SSH_HOST" 'systemctl start bazmi-website-sync.service'

echo "→ Verifying production…"
LIVE=$(ssh "$SSH_HOST" "cat ${WEBROOT}/deployed.txt")
CODE=$(ssh "$SSH_HOST" "curl -sk -o /dev/null -w '%{http_code}' https://${DOMAIN}/")
HEAD=$(git rev-parse HEAD)

echo "  live commit : $LIVE"
echo "  pushed commit: $HEAD"
if [[ "$LIVE" == "$HEAD" && "$CODE" == "200" ]]; then
  echo "✓ Live — https://${DOMAIN} (HTTP $CODE)"
else
  echo "✗ Mismatch or bad status (HTTP $CODE) — check the server" >&2
  exit 1
fi
