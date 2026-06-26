# Yomi's Homelab Power Management

Power documentation for the rack, extension strip, and Home Assistant energy
monitors. The homelab is on UK/EU-style mains; use **220 V** for rough power
calculations unless a measured voltage is available.

## Source of Truth

| Source | Use |
| --- | --- |
| Physical labels on plugs / extension strip | Which device is powered by which outlet |
| Home Assistant (`home.internal.yomitosh.media:8123`) | Live and historical power readings |
| `devices/` docs | Device role and hostname mapping |

Home Assistant is reachable, but the API requires authentication. Do not record
short-lived readings in this file; use it for meter/entity names and long-term
power trends.

## Electrical Assumptions

| Item | Value |
| --- | --- |
| Nominal voltage | 220 V |
| Current estimate | `current A = watts / 220` |
| Power estimate | `watts = volts × amps` |

Keep continuous load below the rating of the extension strip and wall outlet.
If the strip is rated 13 A, the rough continuous ceiling at 220 V is:

```text
220 V × 13 A = 2860 W
```

That is the circuit/strip ceiling, not a target. Leave headroom for inrush,
power-supply inefficiency, and temporary GPU/CPU spikes.

## Physical Layout

The rack currently uses an extension strip. Fill this table from physical plug
labels rather than from transient Home Assistant readings.

| Outlet | Device | Notes |
| --- | --- | --- |
| 1 | YHLD-SERV1 | Proxmox hypervisor |
| 2 | YHLD-SWCH1 | Core switch |
| 3 | YHLD-ACPT1 | WiFi access point |
| 4 | YHLD-IPMI1 | BMC is powered with YHLD-SERV1 |
| 5 | TBD | Spare / unknown |
| 6 | TBD | Spare / unknown |

## Monitors

IKEA power monitors should be documented by stable Home Assistant entity name,
not by current wattage.

| Monitor | Home Assistant entity | Measures | Expected device |
| --- | --- | --- | --- |
| IKEA power monitor 1 | TBD | W / kWh | Extension strip or rack load |
| IKEA power monitor 2 | TBD | W / kWh | TBD |

When Home Assistant auth is available, fill in:

- entity ID, e.g. `sensor.<name>_power`
- energy entity ID, e.g. `sensor.<name>_energy`
- which physical plug or strip it measures
- whether it reports instantaneous W, accumulated kWh, voltage, current, or all of them

## Stable Loads

These are stable inventory items likely to be represented in power monitoring.
Do not enter live wattage here unless it is a long-term observed range.

| Device | Role | Power notes |
| --- | --- | --- |
| [[./devices/YHLD-SERV1.md\|YHLD-SERV1]] | Proxmox hypervisor | Largest baseline load; CPU/GPU/storage spikes expected |
| [[./devices/YHLD-SWCH1/YHLD-SWCH1.md\|YHLD-SWCH1]] | Core switch | Always-on network dependency |
| [[./devices/YHLD-ACPT1/YHLD-ACPT.md\|YHLD-ACPT1]] | WiFi AP | Always-on network dependency |
| [[./devices/YHLD-IPMI1.md\|YHLD-IPMI1]] | Server BMC | Shares server power path |
| [[./devices/YHLD-K1C1.md\|YHLD-K1C1]] | 3D printer | High transient load while heating |

## Operating Rules

- Prefer one documented mapping per plug: outlet → monitor → device.
- Record FQDNs/hostnames and device IDs, not changing DHCP lease addresses.
- Treat printer heaters, GPU workloads, and server boot as spike events.
- Keep network-critical devices on stable power: firewall VM host, switch, AP, and storage.
- Before moving plugs, update this file first or label the physical cable.

## Open Items

- Identify each IKEA power monitor entity in Home Assistant.
- Label each extension strip outlet.
- Confirm extension strip current rating.
- Confirm whether the monitors expose voltage/current as well as power/energy.
