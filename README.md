# PVOptimizer

Home Assistant automations that adjust **battery max charge power** from a **PV forecast**, **state of charge (SOC)**, and simple schedule rules—with optional Pushsafer notifications at fixed hours.

**Home Assistant:** see [compatibility](docs/PVOPTIMIZER.md#home-assistant-compatibility) (target **2024.1+** for the YAML as shipped). **License:** [MIT](LICENSE). **Changes:** [CHANGELOG.md](CHANGELOG.md).

When publishing on GitHub, consider topics such as `home-assistant`, `photovoltaics`, `battery-storage`, `energy-management`, `evcc`, `yaml`.

## Business purpose (why it exists)

This setup assumes the battery is charged from **PV only**. PVoptimizer **moderates** home-battery charging when the forecast is strong so feed-in stays **smoother** (fewer export spikes), neighbors and the **grid operator** see **earlier, more gradual** solar export when the EV is idle, and **lower currents** can be easier on the cells. On **~8 kWp** systems, steadier behavior also helps **EVCC / wallbox** ramp (e.g. **1P 16 A ~3.7 kW** → **3P 6 A ~4.1 kW** → **3P 10 A**). On poor forecast days with low SOC it still **raises** charge speed; when SOC is already fine it **limits** charging (“wait for sun”). When SOC is **at or above** a set threshold (default **95 %** in YAML), the **hourly** run restores the **standard** max charge cap before exception-day and forecast rules. A **configurable weekday** (default Friday) can cap max charge for a known high-demand day, and **evening reset** returns the standard cap from a helper. Full detail: [docs/PVOPTIMIZER.md](docs/PVOPTIMIZER.md#business-purpose).

**Background:** [Comparable tools & stacks](docs/RELATED_PROJECTS.md) (EMHASS, Predbat, examples, evcc).

## Contents

| Path | Purpose |
|------|--------|
| [docs/RELATED_PROJECTS.md](docs/RELATED_PROJECTS.md) | Public repos: EMHASS, Predbat, YAML examples, forecast integrations, **evcc** |
| [docs/PVOPTIMIZER.md](docs/PVOPTIMIZER.md) | Full design, high-SOC max-cap branch, [Open-Meteo](docs/PVOPTIMIZER.md#pv-forecast-open-meteo-solar-forecast), optional [DWD pessimization](docs/PVOPTIMIZER.md#optional-dwd-weather-pessimization), [robustness](docs/PVOPTIMIZER.md#robustness-clamping--valid-range), decision tree |
| [Testing & verification](docs/PVOPTIMIZER.md#testing-and-verification) | Check config, manual run, traces, notifier gating, reset |
| [docs/apexcharts_power_day_swipe.yaml](docs/apexcharts_power_day_swipe.yaml) | **Swipe Card** (HACS): dieselbe Tages-Leistung für **heute … vor 3 Tagen** zum Durchwischen |
| [docs/apexcharts_power_day_card.yaml](docs/apexcharts_power_day_card.yaml) | **ApexCharts Card** (HACS): PV, Netz o. Wallbox, Batterie laden, 2× Wallbox — Tagesansicht |
| [docs/assets/apexcharts_power_day_example.png](docs/assets/apexcharts_power_day_example.png) | **Screenshot** der Tages-Leistung (Flächen für PV + Batterie laden); gilt für **Einzelkarte**; Swipe = gleiche Kurven, mehrere Tage |
| [docs/ENERGY_DASHBOARD_ENTITIES.md](docs/ENERGY_DASHBOARD_ENTITIES.md) | **Optional:** table of HA entity IDs for PV / battery / grid / wallbox charts (installation-specific) |
| [Optional Lovelace card](docs/PVOPTIMIZER.md#optional-dashboard-visualization-lovelace) | Mushroom card: power + max charge cap (`input_number`) |
| [scripts/sync-to-home-assistant.sh](scripts/sync-to-home-assistant.sh) | **Sync** `yaml/*.yaml` → HA `automations/` + `integrations/` (default `HA_CONFIG_ROOT=/Volumes/config`) |
| [yaml/pvoptimizer_helpers.yaml](yaml/pvoptimizer_helpers.yaml) | Optional helpers: standard / exception caps, optional **DWD** tunables |
| [yaml/pvoptimizer_charge.yaml](yaml/pvoptimizer_charge.yaml) | Main automation (copy into HA `config/automations/`) |
| [yaml/pvoptimizer_reset.yaml](yaml/pvoptimizer_reset.yaml) | Evening reset automation |
| [CHANGELOG.md](CHANGELOG.md) | Release notes |
| [LICENSE](LICENSE) | MIT |

1. Copy **`yaml/pvoptimizer_charge.yaml`** and **`yaml/pvoptimizer_reset.yaml`** to **`config/automations/`**. Add **`yaml/pvoptimizer_helpers.yaml`** via **`packages:`** (e.g. `config/integrations/`)—not under **`automations/`**—unless you merge the `input_number` block elsewhere.
2. At the **top** of your `automations.yaml` list (or wherever you keep automations), add:

   ```yaml
   - !include automations/pvoptimizer_charge.yaml
   - !include automations/pvoptimizer_reset.yaml
   ```

3. Ensure `configuration.yaml` includes `automations.yaml` (typical: `automation: !include automations.yaml`).
4. Define the required helpers and entities listed in [docs/PVOPTIMIZER.md](docs/PVOPTIMIZER.md). Replace `notify.lanar` if you use another notifier.
5. **Reload automations** (Developer tools → YAML) or restart Home Assistant.

**Keep repo and live config in sync:** from the repo root, run `./scripts/sync-to-home-assistant.sh` (or set `HA_CONFIG_ROOT` if your config is not `/Volumes/config`). Then reload YAML in HA as needed.

Testing and verification: [docs/PVOPTIMIZER.md — Testing and verification](docs/PVOPTIMIZER.md#testing-and-verification).

## Disclaimer

This repository documents and ships YAML **templates**. Adapt entity IDs, capacities, and notifier services to your installation. No warranty; battery and inverter settings affect hardware and grid behaviour—validate changes in your environment.

Initialize a local repo when you are ready: `git init`, then add remote and push.
