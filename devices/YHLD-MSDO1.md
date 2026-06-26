---
device_name: YHLD-MSDO1
human_name: YHLD Mac Studio 1
location: [[../racks/YHLR-SVRK1.md]]
subnet: ["10.1.10.0/24"]
tags: ["workstation", "mac", "darwin", "nix"]
---

# YHLD Mac Studio 1

## Hardware

| /       |                           |
| ------- | ------------------------- |
| Model   | Mac Studio (M1 Max, 2022) |
| CPU     | Apple M1 Max (10-core)    |
| RAM     | 64 GB                     |
| Storage | 1 TB SSD                  |
| GPU     | Integrated 32-core GPU    |

## Network

| /          |                                  |
| ---------- | -------------------------------- |
| Hostname   | `Mac-Studio` / `Mac-Studio-2`    |
| Connection | Direct SFP+ to firewall (`sfp0`) |
| Segment    | Main LAN / VLAN 10 (`br-main`)   |
| Subnet     | `10.1.10.0/24`                   |

## Configuration Management

Nix-darwin flake: `Mac-Studio`; host directory:
[`hosts/mstdo/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/mstdo).

```bash
darwin-rebuild switch --flake .#Mac-Studio
```

## Notes

- Location: Office desk
- Purpose: Development and multimedia production workstation
- Connected peripherals: 1× QHD ultrawide monitor, external audio interface, MIDI controller
- Backup: Time Machine to `network-share.internal.yomitosh.media`
- Security: FileVault enabled
