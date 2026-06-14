# Bazmi — Landing Site

A sleek, animated **light-theme** landing page for **Bazmi Voice Chat** — a live audio-rooms app where you talk, vibe and belong.

Single self-contained `index.html` (no build step, no dependencies). Just open it or deploy the folder as static files.

## Highlights
- Light theme with a living gradient-blob background + film grain
- Custom trailing cursor & magnetic buttons (desktop)
- A faithful **dark "app screenshot"** of a real Bazmi room — speaking wave-rings, club-level hex badge, crown badges, bottom control bar
- Glass notification toasts, scroll reveals, feature bento grid, animated waveforms

## Structure
```
index.html        # the whole site (HTML + CSS + JS inline)
assets/logo.png   # Bazmi logo
```

## Run locally
```bash
open index.html
# or serve it:
python3 -m http.server 8000   # then visit http://localhost:8000
```

## Deploy

Live at **https://bazmivoicechat.com** (CloudPanel server `187.124.213.14`, web root
`/home/bazmivoicechat/htdocs/bazmivoicechat.com`).

### How it works — pull-based CD

The host sits behind a provider firewall that **drops inbound SSH from datacenter/cloud IP
ranges** (ports 22 *and* 2222 time out from GitHub runners; only 80/443 are open). So a
classic "GitHub Actions pushes over SSH" model can't reach the box. Instead it's pull-based:

```
  push to GitHub  ──►  server systemd timer pulls every 60s  ──►  syncs to web root
                                     │
                                     └─ publishes live commit to /deployed.txt
  GitHub Actions (deploy.yml) ──► polls https://bazmivoicechat.com/deployed.txt
                                  over 443 until it == the pushed commit (pass/fail)
```

So: **just `git push` — production updates within ~60s**, and the Actions run goes green once
it confirms production is serving that commit.

Server pieces (already installed):
- `/usr/local/bin/bazmi-website-sync.sh` — fetch + sync + write `deployed.txt`
- `bazmi-website-sync.timer` / `.service` — runs the sync every 60s
- repo clone at `/opt/bazmi_website`

### Instant manual deploy

To skip the ≤60s wait (pushes the commit, then triggers the server sync immediately):

```bash
./deploy.sh
```

Requires the change committed and SSH access from a non-datacenter IP (a dev machine works).

> nginx note: the vhost's `location /` was switched from a (down) reverse-proxy to
> `try_files $uri $uri/ /index.html`. Backup on the server at
> `…/bazmivoicechat.com.conf.bak-static-deploy`. Changing this site's settings in the
> CloudPanel UI may regenerate the vhost and revert that block — re-apply if so.

---
© 2026 Bazmi Voice Chat · Where voices become a vibe.
