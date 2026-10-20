# 06 — Profiles, settings and release

**Context.** Brief (00) loaded, prompts 01 to 05 done.

## Prompt

Finish the product and prepare it for publication.

**Profiles (`P`).** A list of profiles (the default plus every `profiles/*.yaml`, sorted); `enter`
switches, `esc` cancels. Switching reloads servers, keeps nothing from the old profile, and stops
polling the old servers. `ctrl+r` reloads the current profile from disk while keeping runtime state for
servers that still exist (keyed by ID) and re-resolving the selected server so no stale pointer survives.

**Settings (`c`).** Bar colours (the default gradient, greyscale, or custom start and end hex with
validation), default kill signal, default sort order. Changes apply immediately and are saved to
`settings.yaml`. Provide a live preview of the gradient.

**README.** Written for someone who has never heard of the tool: one-line pitch, a terminal-sized
preview using invented servers (`web-1`, `db-1`, 203.0.113.10), why it exists, features, getting started
with the example config, server requirements (which commands each view needs and what falls back), the key
table, a security section (host keys, plain-text passwords, 0600 files), the licence, and credit to the
libraries used.

**Release checklist.**

- `go build`, `go vet`, `gofmt -l .` and tests are clean; add a minimal CI workflow that runs them.
- `.gitignore` excludes binaries, `config.yaml`, `settings.yaml`, `profiles/`, keys and `.env`.
- `grep` the repo for your real hostnames, IPs, e-mail addresses and key paths. None may appear in
  files or in the commit history; if one does, publish from a fresh repository.
- Licence files in place, version in the header and in the README.
- Tag `v0.1.0`.

## Acceptance checks

- Switching between two profiles with different servers never shows an old server's data.
- Reload while a server is selected and while the dashboard is open: no crash, no stale numbers.
- A custom gradient with invalid hex is rejected with a message and the previous colours stay.
- A fresh clone builds with one command and starts with the example config.
- The repository history contains no private data (author e-mail included).
