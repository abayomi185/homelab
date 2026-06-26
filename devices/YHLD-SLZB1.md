---
device_name: YHLD-SLZB1
human_name: YHLD SLZB 1
location: [[../racks/YHLR-SVRK1.md]]
subnet: ["10.1.50.0/24"]
tags: ["iot", "zigbee", "coordinator"]
---

# YHLD SLZB 1

## Network

| / | Value |
| --- | --- |
| Hostname | `SLZB-MR2` |
| Segment | IoT / VLAN 50 |
| Subnet | `10.1.50.0/24` |

## Notes

Known hostname for the Zigbee coordinator. No static DHCP reservation is currently configured in [`hosts/firewall/dhcp.nix`](https://github.com/abayomi185/nix-dotfiles/blob/main/hosts/firewall/dhcp.nix).
