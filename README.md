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
Any static host works (GitHub Pages, Vercel, Netlify, Cloudflare Pages) — point it at the repo root.

---
© 2026 Bazmi Voice Chat · Where voices become a vibe.
