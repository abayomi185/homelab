---
device_name: YHLD-SWCH1
human_name: YHLD Switch 1
location: [[../../racks/YHLR-SVRK1.md]]
subnet: ["10.1.10.0/24"]
tags: ["switch", "networking"]
---

# YHLD Switch 1

## Hardware

| /       |                           |
| ------- | ------------------------- |
| Chipset | Realtek RTL9302D          |
| Ports   | 2× 10G SFP+, 8× 2.5G RJ45 |
| Console | RJ45                      |

## Network

| /               |                                 |
| --------------- | ------------------------------- |
| Hostname        | `MikroTik_Switch`               |
| Segment         | Main LAN / VLAN 10              |
| Factory default | `192.168.0.1` (`admin`/`admin`) |

## Connected Devices

- **SFP+ ports**: Mac Studio (YHLD-MSDO1), uplink to firewall `sfp0`/`sfp1`
- **2.5G ports**: Access Point (YHLD-ACPT1), GameBox (YHLD-GMBX1), Proxmox host (YHLD-SERV1)

## Backup

SwitchOS backup stored in [`bkp/`](./bkp/).