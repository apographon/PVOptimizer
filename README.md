# PVOptimizer

Home Assistant automations that adjust **battery max charge power** from a **PV forecast**, **state of charge (SOC)**, and simple schedule rules—with optional Pushsafer notifications at fixed hours.

**Home Assistant:** see [compatibility](docs/PVOPTIMIZER.md#home-assistant-compatibility) (target **2024.1+** for the YAML as shipped). **License:** [MIT](LICENSE). **Changes:** [CHANGELOG.md](CHANGELOG.md).

When publishing on GitHub, consider topics such as `home-assistant`, `photovoltaics`, `battery-storage`, `energy-management`, `evcc`, `yaml`.

## Business purpose (why it exists)

This setup assumes the battery is charged from **PV only**. PVoptimizer **moderates** home-battery charging when the forecast is strong so feed-in stays **smoother** (fewer export spikes), neighbors and the **grid operator** see **earlier, more gradual** solar export when the EV is idle, and **lower currents** can be easier on the cells. On **~8 kWp** systems, steadier behavior also helps **EVCC / wallbox** ramp (e.g. **1P 16 A ~3.7 kW** → **3P 6 A ~4.1 kW** → **3P 10 A**). On poor forecast days with low SOC it still **raises** charge speed; when SOC is already fine it **limits** charging (“wait for sun”). **Friday** rule and **evening reset** are habits in the default YAML. Full detail: [docs/PVOPTIMIZER.md](docs/PVOPTIMIZER.md#business-purpose).

## Contents

| Path | Purpose |
|------|--------|
| [docs/PVOPTIMIZER.md](docs/PVOPTIMIZER.md) | Full design, entity requirements, decision tree, tuning |
| [Testing & verification](docs/PVOPTIMIZER.md#testing-and-verification) | Check config, manual run, traces, notifier gating, reset |
| [Optional Lovelace card](docs/PVOPTIMIZER.md#optional-dashboard-visualization-lovelace) | Mushroom card: power + max charge cap (`input_number`) |
| [yaml/pvoptimizer_charge.yaml](yaml/pvoptimizer_charge.yaml) | Main automation (copy into HA `config/automations/`) |
| [CHANGELOG.md](CHANGELOG.md) | Release notes |
| [LICENSE](LICENSE) | MIT |

1. Copy `yaml/pvoptimizer_charge.yaml` and `yaml/pvoptimizer_reset.yaml` to your HA configuration directory, e.g. `config/automations/`.
2. At the **top** of your `automations.yaml` list (or wherever you keep automations), add:

   ```yaml
   - !include automations/pvoptimizer_charge.yaml
   - !include automations/pvoptimizer_reset.yaml
   ```

3. Ensure `configuration.yaml` includes `automations.yaml` (typical: `automation: !include automations.yaml`).
4. Define the required helpers and entities listed in [docs/PVOPTIMIZER.md](docs/PVOPTIMIZER.md). Replace `notify.lanar` if you use another notifier.
5. **Reload automations** (Developer tools → YAML) or restart Home Assistant.

Testing and verification: [docs/PVOPTIMIZER.md — Testing and verification](docs/PVOPTIMIZER.md#testing-and-verification).

## Disclaimer

This repository documents and ships YAML **templates**. Adapt entity IDs, capacities, and notifier services to your installation. No warranty; battery and inverter settings affect hardware and grid behaviour—validate changes in your environment.

Initialize a local repo when you are ready: `git init`, then add remote and push.
