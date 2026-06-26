---
device_name: YHLD-SERV1
human_name: YHLD Server 1
location: [[../racks/YHLR-SVRK1.md]]
subnet: ["10.1.5.0/24", "10.0.7.0/24"]
tags: ["server", "hypervisor", "proxmox", "amd-epyc"]
---

# YHLD Server 1

## Hardware

| /    |                                 |
| ---- | ------------------------------- |
| CPU  | AMD EPYC (1.50 GHz – 3.31 GHz)  |
| Role | Proxmox VE hypervisor           |
| BMC  | [[./YHLD-IPMI1.md\|YHLD-IPMI1]] |

## Network

| Name | Address | Source |
| ---- | ------- | ------ |
| `pve.internal.yomitosh.media` | `10.1.5.12` | Firewall static DNS |
| `pve-firewall.internal.yomitosh.media` | `10.1.5.11` | Firewall static DNS |
| `proxmox.*` app route | `https://10.0.7.1:8006` | Traefik dynamic config |

## CPU Tuning

| Setting | Value |
| ------- | ----- |
| Governor target | `powersave` |
| Energy performance preference target | `power` |
| Available governors | `conservative`, `ondemand`, `userspace`, `powersave`, `performance`, `schedutil` |
| Boost | Supported but inactive |

Applied at boot via crontab `@reboot` entries (see Notes below).

## Virtual Machines

| VM | Role | Management | Cluster | Config |
| -- | ---- | ---------- | ------- | ------ |
| `firewall` | Router / firewall | gateways on all LAN segments | n/a | [`hosts/firewall/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/firewall) |
| `knode1` | k3s server / init | `10.1.5.71` | `10.0.7.41` | [`hosts/knode/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/knode) |
| `knode2` | k3s agent | `10.1.5.72` | `10.0.7.42` | [`hosts/knode/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/knode) |
| `knode3` | k3s agent | `10.1.5.73` | `10.0.7.43` | [`hosts/knode/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/knode) |
| `knode4` | k3s agent / Intel GPU node | `10.1.5.74` | not configured in flake | [`hosts/knode/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/knode) |

## LXC Containers

| Container / flake attr | Runtime hostname | Role | Cluster | Config |
| ---------------------- | ---------------- | ---- | ------- | ------ |
| `kloadbalancer` | `kloadbalancer.internal.yomitosh.media` | Traefik ingress | `10.0.7.40` | [`hosts/lxc/load-balancer/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/lxc/load-balancer) |
| `network-share` | `network-share.internal.yomitosh.media` | NAS (NFS/SMB/FTP), Time Machine, k8s NFS | `10.0.7.202` | [`hosts/lxc/network-share/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/lxc/network-share) |
| `audio-share` | `l-audio-share.internal.yomitosh.media` | Spotifyd, PipeWire/AirPlay, Scream receiver | `10.0.7.203` | [`hosts/lxc/audio-share/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/lxc/audio-share) |
| `machine-learning` | `machine-learning.internal.yomitosh.media` | GPU compute / llama-server | `10.0.7.250` | [`hosts/lxc/machine-learning/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/lxc/machine-learning) |

`machine-learning.internal.yomitosh.media` has a NixOS config and Home Manager config, but its
`nixosConfigurations` flake entry is currently commented out because the NVIDIA
driver-in-LXC path is not working yet.

## Notes

```sh
# To see CPU frequency information on Linux:
cpupower frequency-info
```

Crontab has been set up as follows:

```sh
# Set CPU governor to powersave on reboot
@reboot cpupower frequency-set -g powersave
# Set energy performance preference (AMD pstate) to "power" on reboot
@reboot /bin/bash -c 'echo "power" | tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference'
```

To check energy performance preference options:

```sh
cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_available_preferences
```
