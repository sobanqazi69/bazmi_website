#!/usr/bin/env bash
#
# Deploy the Bazmi landing site to the production server.
# Usage:  ./deploy.sh
#
# Uploads index.html + assets/ to the CloudPanel web root, fixes ownership,
# and verifies the site responds. Static files only — no nginx reload needed.

set -euo pipefail

# ── Config ────────────────────────────────────────────────
SSH_HOST="root@187.124.213.14"
SITE_USER="bazmivoicechat"
DOMAIN="bazmivoicechat.com"
WEBROOT="/home/${SITE_USER}/htdocs/${DOMAIN}"

# Files/dirs to deploy (relative to this script's directory).
ASSETS=(index.html assets)

# ──────────────────────────────────────────────────────────
cd "$(dirname "$0")"

echo "→ Uploading to ${SSH_HOST}:${WEBROOT}"
for item in "${ASSETS[@]}"; do
  if [[ -d "$item" ]]; then
    scp -q -o BatchMode=yes -r "$item" "${SSH_HOST}:${WEBROOT}/"
  else
    scp -q -o BatchMode=yes "$item" "${SSH_HOST}:${WEBROOT}/"
  fi
  echo "  ✓ $item"
done

echo "→ Fixing ownership & permissions"
ssh -o BatchMode=yes "$SSH_HOST" "
  chown -R ${SITE_USER}:${SITE_USER} ${WEBROOT}/index.html ${WEBROOT}/assets
  chmod 644 ${WEBROOT}/index.html
  chmod 755 ${WEBROOT}/assets
  find ${WEBROOT}/assets -type f -exec chmod 644 {} +
"

echo "→ Verifying https://${DOMAIN}"
CODE=$(ssh -o BatchMode=yes "$SSH_HOST" "curl -sk -o /dev/null -w '%{http_code}' https://${DOMAIN}/")
if [[ "$CODE" == "200" ]]; then
  echo "✓ Live — https://${DOMAIN} (HTTP $CODE)"
else
  echo "✗ Unexpected status: HTTP $CODE — check the server" >&2
  exit 1
fi
