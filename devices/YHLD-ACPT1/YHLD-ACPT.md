---
device_name: YHLD-ACPT1
status: decommissioned # sold
human_name: YHLD Access Point 1
subnet: ["10.1.10.0/24", "10.1.50.0/24"]
tags: ["ap", "access-point", "networking", "wifi"]
---

# YHLD Access Point 1

## Hardware

| /       |                   |
| ------- | ----------------- |
| Model   | MikroTik wAP ax   |
| WiFi    | WiFi 6 (802.11ax) |

## Network

| /               |                     |
| --------------- | ------------------- |
| Hostname        | `MikroTik`          |
| Management VLAN | 10 (main)           |
| WLAN VLANs      | 10 (main), 50 (IoT) |
| Factory default | `192.168.0.1`       |

## Backup

MikroTik configuration backup stored in [`bkp/`](./bkp/).