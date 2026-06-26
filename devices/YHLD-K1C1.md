---
device_name: YHLD-K1C1
human_name: YHLD K1C 1
location: [[../racks/YHLR-SVRK1.md]]
subnet: ["10.1.50.0/24"]
tags: ["iot", "printer", "3d-printer"]
---

# YHLD K1C 1

## Network

| / | Value |
| --- | --- |
| Hostname | `k1c` |
| Segment | IoT / VLAN 50 |
| Subnet | `10.1.50.0/24` |
| Static reservation | `10.1.50.83` / `fc:ee:28:03:6c:d5` |

## Services

Traefik routes `k1c.internal.yomitosh.media` to the device service on port `4409`.
