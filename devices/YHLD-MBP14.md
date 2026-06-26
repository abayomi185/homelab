---
device_name: YHLD-MBP14
human_name: YHLD MacBook Pro 14
location: mobile
subnet: ["10.1.10.0/24"]
tags: ["laptop", "mac", "darwin", "nix"]
---

# YHLD MacBook Pro 14

## Hardware

| / | Value |
| --- | --- |
| Model | MacBook Pro 14-inch (MacBookPro18,4) |
| Platform | Apple Silicon (`aarch64-darwin`) |

## Network

| / | Value |
| --- | --- |
| Segment | Main LAN / VLAN 10 |
| Subnet | `10.1.10.0/24` |
| Hostname / flake | `MacBook-Pro-14` |

## Configuration Management

Nix-darwin flake: `MacBook-Pro-14`; host directory:
[`hosts/mbp14/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/mbp14).

```bash
darwin-rebuild switch --flake .#MacBook-Pro-14
```
