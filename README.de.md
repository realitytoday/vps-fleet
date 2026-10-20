# vps-fleet — ein Bauplan für dein eigenes Server-Cockpit

*English version: [README.md](README.md)*

**Die ganze Server-Flotte in einem Terminalfenster.** Eine schnelle, tastaturgesteuerte
Terminal-Oberfläche für alle, die ein paar VPS betreiben und keine Lust mehr auf einen
Haufen SSH-Tabs haben: Zustand aller Server live, Dashboard mit Trends und Prozessliste,
ein Befehls-Runner, ein systemd-Manager und ein Zwei-Fenster-Dateimanager, alles über
normales SSH, ohne etwas auf den Servern zu installieren.

Gebaut in wenigen Tagen im September 2026 mit KI-Coding-Agenten. Dieses Repository ist
**der Prompt**: Idee, Architektur, Regeln und die geordneten Bau-Briefings. Das Ergebnis
liegt separat als Referenzimplementierung vor:
**[vps-fleet-tui](https://github.com/realitytoday/vps-fleet-tui)** (Go, MIT).

- **Idee** und was bewusst nicht gebaut wird: [docs/01-concept.md](docs/01-concept.md)
- **Architektur** samt Begründungen: [docs/02-architecture.md](docs/02-architecture.md)
- **Bildschirme und Tastenbelegung:** [docs/03-ux-and-keys.md](docs/03-ux-and-keys.md)
- **Lessons Learned:** [docs/04-lessons-learned.md](docs/04-lessons-learned.md)
- **Prompts** für den eigenen Coding-Agenten: [prompts/](prompts/README.md)
- **Referenzmaterial:** Shell-Schnipsel und eine Beispielkonfiguration: [reference/](reference/README.md)

## Warum ein Bauplan neben dem Code?

Den Code kannst du direkt nutzen. Aber so ein Werkzeug ist schnell erzeugt und sehr
persönlich: Deine Server laufen mit Debian, Alpine oder Rocky, du willst Docker statt
systemd verwalten oder andere Tastenkürzel. Eine präzise Beschreibung dessen, *was*
gebaut wird, *warum* so entschieden wurde und *wo es bricht*, lässt sich besser
übertragen als fertiger Code. Dein Agent passt sie an deine Umgebung an.

## So gehst du vor

1. Konzept und Architektur lesen (ca. 10 Minuten).
2. Entscheiden, was du brauchst. Ab Prompt 04 ist alles optional.
3. [prompts/00-project-brief.md](prompts/00-project-brief.md) als `CLAUDE.md` in ein
   neues Repo legen und die Platzhalter ausfüllen.
4. Die Prompts 01 bis 06 der Reihe nach abarbeiten, jeweils gegen einen echten Server
   testen und die Abnahmekriterien prüfen.
5. Von Anfang an ein Entscheidungsprotokoll führen.

## Lizenz

Doppelt lizenziert. Text und Prompts: [CC BY 4.0](LICENSE-docs.md). Code und
Konfiguration unter `reference/`: [MIT](LICENSE).
