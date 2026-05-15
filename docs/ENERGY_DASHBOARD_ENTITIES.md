# Energy dashboard — entity reference (installation-specific)

Reference for **power / energy visualizations** (e.g. ApexCharts, Energy dashboard).  
IDs below match this Home Assistant installation; replace or fork for other sites.

## ApexCharts: day power chart (two layouts)

Example (this installation — **single-day** card, PV and battery as **areas**):

![ApexCharts: Leistung heute (W) — PV (DC), Netz ohne Wallboxen, Wallboxen, Batterie laden](assets/apexcharts_power_day_example.png)

Dieselbe **Kurven-/Flächen**-Darstellung verwenden **`apexcharts_power_day_card.yaml`** (nur **heute**) und **`apexcharts_power_day_swipe.yaml`** (**heute** + **3 vorherige Tage** per Wischen); der Screenshot zeigt die **Einzelkarte**.

| Layout | File in repo | Depends on |
|--------|----------------|------------|
| **One card** (calendar today, `now` marker) | [`apexcharts_power_day_card.yaml`](apexcharts_power_day_card.yaml) | HACS **ApexCharts Card**; template `sensor.grid_net_excl_wallboxes` (see below); power entity for battery (e.g. `sensor.battery_charging_power`), **not** kWh energy. |
| **Swipe** (today + 3 previous days) | [`apexcharts_power_day_swipe.yaml`](apexcharts_power_day_swipe.yaml) | Same as above + HACS **Swipe Card** (`custom:swipe-card`). Older days use `now: false`. |

Paste the YAML into the dashboard **raw editor** as one card (swipe wraps several `custom:apexcharts-card` children). After edits in the repo, keep HA in sync (e.g. `./scripts/sync-to-home-assistant.sh` for automations/helpers; chart YAML is documentation-only unless you copy it manually).

## Entities

| Role | Entity ID | Notes |
|------|-----------|--------|
| PV (roof / strings, DC sum) | `sensor.total_dc_power` | **DC**-side total; AC inverter output can differ slightly. Unit is usually **W** (confirm in Developer tools). |
| Battery **power** (charging, W) | `sensor.battery_charging_power` (example) | For **power-over-time** charts use **`device_class: power`** / **W**. |
| Battery **energy** (e.g. daily charge) | `sensor.battery_charge` / `sensor.battery_charge_nominal` | Often **kWh** or cumulative **energy** — **not** the same as power; wrong choice flattens on 0 or shows kWh in a W chart. |
| Grid net (import / export) | `sensor.net_consumption_rounded` | **Raw grid coupling** vs. site load. **Important:** for analysis and charts, treat **`net_consumption_rounded` as including wallbox load** — **subtract both wallbox powers** to get grid flow **without** EV charging (see [Grid excluding wallboxes](#grid-excluding-wallboxes)). **Sign convention:** confirm in HA (often **positive = grid import**, **negative = export**). |
| Net grid excl. wallboxes (computed) | `sensor.grid_net_excl_wallboxes` | **`net_consumption_rounded − carport − garage`**; wallbox **unavailable** → **0 W**. Defined in **`yaml/pvoptimizer_helpers.yaml`**. |
| Wallbox carport | `sensor.carport_power` | Often **kW** in the UI — chart uses a **second y-axis** in kW. Template subtracts wallbox power in **W**. |
| Wallbox garage | `sensor.garage_power` | Same as carport. |

## Grid excluding wallboxes

**Intent:** same sign convention as `sensor.net_consumption_rounded`, but **without** Carport- und Garage-Wallbox-Leistung.

\[
\text{grid}_{\text{excl. EV}} \approx \text{net\_consumption\_rounded} - \text{carport\_power} - \text{garage\_power}
\]

**Assumptions (verify on your site):**

- **`net_consumption_rounded`** is comparable to wallbox power in **W** (after converting wallbox **kW** in the template below).
- **`carport_power`** / **`garage_power`:** if state is **`unknown`**, **`unavailable`**, **`none`**, or empty, treat power as **0** (same as idle). If `unit_of_measurement` is **kW**, the template multiplies by **1000** before subtracting from net.

### Template sensor (`sensor.grid_net_excl_wallboxes`)

Defined in **`yaml/pvoptimizer_helpers.yaml`** together with the other PVoptimizer helpers. Include that file under **`homeassistant: packages:`**, then **check configuration** and reload **YAML configuration** (or restart). Entity id: **`sensor.grid_net_excl_wallboxes`**.

If you **do not** use `pvoptimizer_helpers.yaml`, paste the block below under `template:` elsewhere:

```yaml
template:
  - sensor:
      - name: Grid net excl. wallboxes
        unique_id: pvoptimizer_grid_net_excl_wallboxes_w
        unit_of_measurement: W
        device_class: power
        state_class: measurement
        state: >
          {% set net = states('sensor.net_consumption_rounded') | float(0) %}
          {% set bad = ['unknown', 'unavailable', 'none', ''] %}
          {% set cp = states('sensor.carport_power') %}
          {% set gr = states('sensor.garage_power') %}
          {% set mcp = namespace(x=1) %}
          {% set mgr = namespace(x=1) %}
          {% if cp not in bad %}
            {% set u = state_attr('sensor.carport_power', 'unit_of_measurement') | default('', true) | lower | replace('kilowatt','kw') %}
            {% if u == 'kw' %}{% set mcp.x = 1000 %}{% endif %}
          {% endif %}
          {% if gr not in bad %}
            {% set u = state_attr('sensor.garage_power', 'unit_of_measurement') | default('', true) | lower | replace('kilowatt','kw') %}
            {% if u == 'kw' %}{% set mgr.x = 1000 %}{% endif %}
          {% endif %}
          {% set cp_w = 0 if cp in bad else cp | float(0) * mcp.x %}
          {% set gr_w = 0 if gr in bad else gr | float(0) * mgr.x %}
          {{ (net - cp_w - gr_w) | round(0) }}
```

Use this entity in ApexCharts instead of raw `net_consumption_rounded` when you want **Netz ohne Wallboxen**. Ready-made card: **[`apexcharts_power_day_card.yaml`](apexcharts_power_day_card.yaml)**. **Multiple days:** swipe variant **[`apexcharts_power_day_swipe.yaml`](apexcharts_power_day_swipe.yaml)** (requires HACS **Swipe Card**).

### Chart vs. data: export not visible, wallboxes flat

1. **Y-axis `min: 0`:** clips **negative** net values (typical **grid export**). Use **`min: auto`** on the watt axis (as in the current example YAML).
2. **Wallbox in kW, PV in W:** on one axis, charger power (e.g. **3.7**) sits on a **0…8000 W** scale → invisible. Use the **second y-axis (kW)** in the example cards or put wallbox series on the **`w`** axis only if the entity is already **W**.
3. **`group_by` `max` on signed grid power:** can bias bins; the examples use **`avg`** for **`sensor.grid_net_excl_wallboxes`** (ApexCharts Card keyword, not `mean`).
4. **Wrong subtraction:** if wallboxes are **kW** but subtracted as **W**, `grid_net_excl_wallboxes` is wrong — the template in **`pvoptimizer_helpers.yaml`** converts **kW** wallboxes using `unit_of_measurement`.
5. **Sign in chart:** HA often reports **grid import as positive** and **export (Einspeisung) as negative**. The example cards apply **`transform: return -1 * parseFloat(x)`** on the net series so **feed-in plots upward (positive)** and import downward. Remove that line if your entity already uses the opposite convention.

## Derived ideas (optional)

- **Total wallbox power:** `carport_power` + `garage_power` (second series in chart or small template sensor).
- **House load without EV:** depends on definitions; with the subtraction above you isolate **grid coupling excluding EV**. Full “Haus ohne alles” may still need PV/battery terms — sign conventions matter.
- **Daily kWh (PV / battery / house):** separate from these **instant power** sensors — use **Energy dashboard** assignments, **integration sensors**, or **utility_meter** on energy entities.

## Checks before chart YAML

1. Developer tools → **States**: unit (`W` / `kW`), update frequency, `unknown` behaviour.  
2. History: open each entity and confirm curves look plausible for one day.  
3. **Net consumption:** note whether positive means import — document here once verified:

   - `sensor.net_consumption_rounded`: positive = *(fill in: import / export)*  
   - For charts **without wallbox share**, use **`net_consumption_rounded − carport_power − garage_power`** (or the template sensor in [§ Grid excluding wallboxes](#grid-excluding-wallboxes)).

4. **Battery:** chosen canonical entity for charts: *(fill in: `sensor.…`)*
