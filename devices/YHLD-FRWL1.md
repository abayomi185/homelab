---
device_name: YHLD-FRWL1
human_name: YHLD Firewall 1
location: [[../racks/YHLR-SVRK1.md]]
tags: ["firewall", "networking", "security", "nixos"]
---

# YHLD Firewall 1

NixOS VM (VMID 506) on [[YHLD-SERV2/YHLD-SERV2.md|YHLD-SERV2]]. Replaced
OPNsense. Single router, NAT gateway, DHCP/DNS server, WireGuard client and
UniFi controller for the homelab.

Config: [`hosts/firewall/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/firewall).
Segments and cabling: [[../NETWORKING.md|NETWORKING]].

## Notes

- NICs are MAC-pinned to names via systemd `.link` files; the Proxmox VM MACs must match the config or the router won't come up.
- WireGuard: firewall dials out to the VPS (`wireguard.yomitosh.media`); no inbound port.
- Cluster network `10.0.7.0/24` is not routed here; only DNS records point into it.

## Management

```bash
nixos-rebuild switch --flake .#firewall --target-host root@firewall.internal.yomitosh.media
```
