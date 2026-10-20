# Reference material

Small, sanitized pieces that are hard to get right without a real server. Treat them as the
**target behaviour**, not a drop-in install: adapt them to the tools your servers actually have.

| File | What it is |
|---|---|
| `remote/metrics.sh` | The per-poll metrics script: one prefixed line per metric, two samples 0.5 s apart |
| `remote/updates.sh` | Pending package updates (apt, dnf, apk) without network access |
| `remote/processes.sh` | `top` second frame with a `ps` fallback |
| `remote/list-dir.sh` | One directory level with all fields the file manager shows |
| `config.example.yaml` | Server list format (invented servers in the documentation IP range) |
| `settings.example.yaml` | The settings file and its defaults |

All of it is MIT licensed. The complete Go implementation these prompts produce is in
[vps-fleet-tui](https://github.com/realitytoday/vps-fleet-tui).
