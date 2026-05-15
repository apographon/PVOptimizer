# Changelog

All notable changes to this project are documented here. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- **`docs/assets/apexcharts_power_day_example.png`**: screenshot for the ApexCharts day-power documentation (PV and battery as filled areas).
- **`scripts/sync-to-home-assistant.sh`**: copies **`yaml/pvoptimizer_*.yaml`** to a live config tree (default **`HA_CONFIG_ROOT=/Volumes/config`** → `automations/` + `integrations/`). Run from repo root after edits; then reload automations / templates in HA.
- **`pvoptimizer_helpers.yaml`**: template sensor **`sensor.grid_net_excl_wallboxes`** (`net_consumption_rounded` − wallboxes; unavailable → 0).
- **`docs/apexcharts_power_day_swipe.yaml`**: Swipe Card — heute bis vor 3 Tagen (HACS).
- **`docs/apexcharts_power_day_card.yaml`**: ApexCharts-Leistungskarte (Kalendertag) für PV, `grid_net_excl_wallboxes`, Batterie, Wallboxen.
- **`docs/ENERGY_DASHBOARD_ENTITIES.md`**: optional table of entity IDs for PV / battery / grid / wallbox charts (installation-specific).
- **PV forecast DWD pessimization (optional):** `input_boolean` + `pvoptimizer_dwd_*` in **`pvoptimizer_helpers.yaml`**; **`pv_forecast`** in **`pvoptimizer_charge.yaml`** when enabled.
- **`docs/PVOPTIMIZER.md`**: **Open-Meteo** walkthrough + **optional DWD pessimization** section (entity ids, helpers).
- `docs/RELATED_PROJECTS.md` — curated links to alternative approaches; linked from README.

### Changed

- **`docs/apexcharts_power_day_card.yaml`** / **`swipe`**: Y-Achse Watt **`min: auto`** (Export nach unten); **Netz**-Serie `group_by: mean`; Wallboxen auf **rechter Achse kW**. **`pvoptimizer_helpers.yaml`**: Abzug Wallbox **kW** → W per `unit_of_measurement`. **`ENERGY_DASHBOARD_ENTITIES.md`**: Troubleshooting + Template angepasst.
- **`docs/ENERGY_DASHBOARD_ENTITIES.md`**: document **grid net excl. wallboxes** (`net_consumption_rounded` − `carport_power` − `garage_power`) + optional template sensor.
- **`pvoptimizer_charge.yaml`**: If **clamped** SOC **≥** **`soc_voller_akku_schwelle_pct`** (default **95**), inner **`choose`** sets **`max_charge_w`** and **`soc_nahe_voll_max`** first (overrides exception weekday and forecast arms). **`docs/PVOPTIMIZER.md`** and **`README`** updated.
- **Docs:** `docs/PVOPTIMIZER.md` and `README` updated for **`state_attr` write bounds**, **robustness** section, install paths (automations vs packages), and testing notes.
- **Language:** All documentation (`README`, `docs/PVOPTIMIZER.md`) and user-facing Home Assistant strings (automation **aliases**, **descriptions**, **notify** title/message, helper **`name:`** fields) are **English**. Values written to **`input_text.battery_charge_decision`** stay as compact tokens (e.g. `geladen`, `kein_zweig`) for backward compatibility.
- **`pvoptimizer_charge.yaml`**: Missing SOC or forecast → set max charge to **`input_number.pvoptimizer_max_charge_w`** (fallback 5000), decision **`daten_unvollstaendig`**; no longer skips the automation run at `conditions` level.
- **Configurable caps**: **`pvoptimizer_max_charge_w`**, **`pvoptimizer_exception_max_charge_w`**, **`pvoptimizer_exception_weekday`** (0=Mon … 6=Sun) via package **`pvoptimizer_helpers.yaml`**; exception branch sets **`sonder_tag_forciert`**.
- **Sungrow SOC window**: **`batterieladung` / `bedarf` / dynamic power** use **`input_number.set_sg_max_soc`** and **`sensor.battery_capacity`**; “bad day, low buffer” vs “wait for sun” compares SOC to **`input_number.set_sg_reserved_soc_for_backup`**.
- **`pvoptimizer_charge.yaml` / `pvoptimizer_reset.yaml`**: Write clamp **`min`/`max`** from **`input_number.set_sg_battery_max_charge_power`** (**fallback 0 / 20000** if attributes missing).

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
