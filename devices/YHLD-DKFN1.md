---
device_name: YHLD-DKFN1
human_name: YHLD Desk Fan 1
location: office
subnet: ["10.1.50.0/24"]
tags: ["iot", "fan"]
---

# YHLD Desk Fan 1

## Network

| / | Value |
| --- | --- |
| Hostname | `yhld-dkfn1` |
| Segment | IoT / VLAN 50 |
| Subnet | `10.1.50.0/24` |

## Notes

IoT desk fan. No static DHCP reservation is currently configured in [`hosts/firewall/dhcp.nix`](https://github.com/abayomi185/nix-dotfiles/blob/main/hosts/firewall/dhcp.nix).
