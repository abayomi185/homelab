---
device_name: YHLD-WRPT1
human_name: YHLD WiFi Repeater 1
location: mobile
subnet: ["10.1.10.0/24", "192.168.50.0/24"]
tags: ["wifi", "repeater", "raspberry-pi", "nixos"]
---

# YHLD WiFi Repeater 1

## Hardware

| / | Value |
| --- | --- |
| Host hardware | Raspberry Pi 4B or Pi 400 |
| WiFi adapter | ALFA AWUS0360ACS (RTL8811AU, USB 2.0) |
| Storage | SD card, 16 GB+ |

## Network

| / | Value |
| --- | --- |
| Hostname | `wifi-repeater.internal.yomitosh.media` / `wifi-repeater.local` |
| Upstream | `eth0`, DHCP from main router |
| Downstream | `wlan0`, `192.168.50.1/24` |
| Downstream DHCP | `192.168.50.10`–`192.168.50.200` |
| SSID | `Airport` |

NAT is enabled from `wlan0` clients to `eth0`.

## Configuration Management

NixOS flake: `wifi-repeater`; host directory:
[`hosts/wifi-repeater/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/wifi-repeater).

```bash
nixos-rebuild switch --flake .#wifi-repeater --target-host root@wifi-repeater.local
```
