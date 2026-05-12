# Related public projects & approaches

PVoptimizer is intentionally **lightweight**: rule-based YAML, hourly updates, PV-focused battery **max charge power**. Other repos tackle the same problem space with **different trade-offs** (optimization depth, vendor lock-in, forecast plumbing). None are endorsements—evaluate fit for your hardware and privacy.

## Optimization & prediction (heavier stack)

| Project | Link | Approach (short) |
|--------|------|-------------------|
| **EMHASS** | [github.com/davidusb-geek/emhass](https://github.com/davidusb-geek/emhass) | Energy management for Home Assistant using **linear programming**; PV, battery, tariffs, deferrable loads. Docs: [emhass.readthedocs.io](https://emhass.readthedocs.io) |
| **Predbat (Batpred)** | [github.com/springfall2008/batpred](https://github.com/springfall2008/batpred) | Forecast- and tariff-driven **battery planning** for many inverter families; broad automation surface |

## YAML / Home Assistant packages (examples)

| Project | Link | Approach (short) |
|--------|------|-------------------|
| Solar battery forecast package (example) | [ManfredTremmel/home_assistant_config – package YAML](https://github.com/ManfredTremmel/home_assistant_config/blob/main/packages/010_solar_battery_forcast_based_loading_package.yaml) | HA **package**: forecast-based loading logic (example config, not a standalone product) |
| Huawei-oriented optimizations | [github.com/heinoskov/huawei-solar-battery-optimizations](https://github.com/heinoskov/huawei-solar-battery-optimizations) | Scripts/automations for **Huawei Solar**, forecast and pricing hooks |
| Solar forecast charge prediction | [github.com/HAuser1234/Homeassistant-solar-forecast-charge-prediction](https://github.com/HAuser1234/Homeassistant-solar-forecast-charge-prediction) | Smaller **offline** HA-oriented project: charge-state prediction / UI ideas |

## Forecast data sources (building blocks)

| Project | Link | Approach (short) |
|--------|------|-------------------|
| **Open-Meteo Solar Forecast** (HA custom integration) | [github.com/rany2/ha-open-meteo-solar-forecast](https://github.com/rany2/ha-open-meteo-solar-forecast) | Free PV **energy** forecast in HA; pairs well with rule-based logic—setup in [PVOPTIMIZER.md § Open-Meteo](PVOPTIMIZER.md#pv-forecast-open-meteo-solar-forecast) |
| **Solcast** (custom component) | [github.com/HandyHat/ha-solcast-solar](https://github.com/HandyHat/ha-solcast-solar) | **Solcast** PV forecast entities—you supply the strategy |

Core **Forecast.Solar** and vendor-specific forecasts are also common; match **“full day”** vs **“remaining today”** to your automation ([PVOPTIMIZER.md — Assumptions](PVOPTIMIZER.md#assumptions-and-caveats)).

## EV charging / V1G alongside PVoptimizer

| Project | Link | Notes |
|--------|------|--------|
| **evcc** | [github.com/evcc-io/evcc](https://github.com/evcc-io/evcc) | Wallbox and surplus control; **V1G**-style smart charging. Often runs **parallel** to home-battery rules: coordinate **who gets power** (battery vs EV) so limits stay coherent. |

## How this compares to PVoptimizer

- **PVoptimizer**: transparent **if/else** logic, minimal dependencies, **max charge power** as the main actuator.  
- **EMHASS / Predbat**: stronger **optimization** or planning, more configuration and moving parts.  
- **evcc**: different layer (**EV** charging), complementary if priorities and power budgets are clear.

---

Back to [README](../README.md) · [Full design (PVOPTIMIZER.md)](PVOPTIMIZER.md)
