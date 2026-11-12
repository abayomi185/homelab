---
device_name: YHLD-VPSR1
human_name: YHLD VPS Remote 1
location: off-site (Euronodes)
tags: ["vps", "nixos", "wireguard", "k3s"]
---

# YHLD VPS Remote 1

## Hardware

| /        |                     |
| -------- | ------------------- |
| Provider | Euronodes           |
| Type     | x86_64 KVM VPS      |
| OS       | NixOS               |

## Role

- **WireGuard hub** for remote clients. Took over the tunnel identity of the
  retired `vps-arm64`, so existing peers kept the same server key.
- **k3s agent** joined to `knode1`, labelled `yomitosh.media/role=vps-public`.
  Public HTTP/HTTPS for in-cluster Traefik lands here.
- VPN-only helper services (FlareSolverr, tinyproxy) on `wg0`.

Config: [`hosts/yhld-vpsr1/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/yhld-vpsr1).
