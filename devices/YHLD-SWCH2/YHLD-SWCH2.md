---
device_name: YHLD-SWCH2
human_name: YHLD UniFi Switch 2
location: [[../../racks/YHLR-SVRK1.md]]
subnet: ["10.1.5.0/24"]
tags: ["switch", "networking", "unifi"]
---

# YHLD UniFi Switch 2

Core switch. Managed by the UniFi controller on [[../YHLD-FRWL1.md|YHLD-FRWL1]];
management on Infra VLAN as `yhld-swch2`.

## Hardware

| / | |
| --- | --- |
| Model | UniFi USW-Pro-24-PoE |
| MAC | `d0:21:f9:4b:f6:ea` |
| Ports | 24× 1 GbE PoE, 2× 10G SFP+ |

## Cabling

| Port | Connected to |
| --- | --- |
| 1 | YHLD-ACPT2 (PoE) |
| 7 | YHLD-SLZB1 (IoT) |
| 11 | YHLD-IPMI1 |
| 25 (SFP+) | YHLD-SERV2 SFP1, firewall trunk |
| 26 (SFP+) | YHLD-SERV1 |
