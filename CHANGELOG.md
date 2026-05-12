# Changelog

All notable changes to this project are documented here. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [1.0.0] — 2026-05-12

### Added

- `yaml/pvoptimizer_charge.yaml` — hourly PV forecast / SOC logic, Pushsafer gate at **08:00** and **12:00** (`minute == 0`), `system_log.write` (`pvoptimizer`), optional **sensor gate** (SOC + forecast must be valid before actions).
- **Catch-all branch** `kein_zweig` when no forecast/SOC arm matches (e.g. forecast ≥ threshold but still below `bedarf`); does not change `input_number`.
- `yaml/pvoptimizer_reset.yaml` — evening reset of max charge power.
- `docs/PVOPTIMIZER.md` — business purpose, decision flow, testing, optional Mushroom card (with screenshot), YAML pitfalls.
- `docs/assets/mushroom-battery-card.png` — dashboard example.
- `LICENSE` (MIT).

### Changed

- Documentation: table of contents, Home Assistant compatibility note, Lovelace template hides **Max** when `input_number` is unavailable.
