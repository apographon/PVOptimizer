#!/usr/bin/env bash
# Copy PVOptimizer YAML from this repo to a live Home Assistant config tree.
# Usage: ./scripts/sync-to-home-assistant.sh
# Override path:  HA_CONFIG_ROOT=/path/to/config ./scripts/sync-to-home-assistant.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HA_ROOT="${HA_CONFIG_ROOT:-/Volumes/config}"

for d in "$HA_ROOT/automations" "$HA_ROOT/integrations"; do
  if [[ ! -d "$d" ]]; then
    echo "ERROR: directory not found: $d" >&2
    echo "Set HA_CONFIG_ROOT to your Home Assistant configuration directory." >&2
    exit 1
  fi
done

cp -f "$REPO_ROOT/yaml/pvoptimizer_charge.yaml" "$HA_ROOT/automations/pvoptimizer_charge.yaml"
cp -f "$REPO_ROOT/yaml/pvoptimizer_reset.yaml" "$HA_ROOT/automations/pvoptimizer_reset.yaml"
cp -f "$REPO_ROOT/yaml/pvoptimizer_helpers.yaml" "$HA_ROOT/integrations/pvoptimizer_helpers.yaml"

echo "Synced to $HA_ROOT:"
echo "  automations/pvoptimizer_charge.yaml"
echo "  automations/pvoptimizer_reset.yaml"
echo "  integrations/pvoptimizer_helpers.yaml"
echo "Reload automations / template entities in Home Assistant as needed."
