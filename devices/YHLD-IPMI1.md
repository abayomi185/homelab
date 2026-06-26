---
device_name: YHLD-IPMI1
human_name: YHLD Supermicro IPMI 1
location: [[../racks/YHLR-SVRK1.md]]
subnet: ["10.1.5.0/24"]
tags: ["ipmi", "YHLD-SERV1"]
---

# YHLD IPMI 1 (For YHLD Server 1)

## Network

| /        |                           |
| -------- | ------------------------- |
| Hostname | `supermicro-ipmi.internal.yomitosh.media` |
| Segment  | Infra / VLAN 5 (`sfp1.5`) |

## Fan Thresholds

Lowered from factory defaults to reduce noise:

```bash
ipmitool sensor thresh "FAN4" lower 200 300 400
```

To inspect current thresholds:

```bash
ipmitool sensor list all
```

Threshold format for `sensor thresh`:

```text
lower <Non-Recoverable> <Critical> <Non-Critical>
upper <Non-Critical> <Critical> <Non-Recoverable>
```