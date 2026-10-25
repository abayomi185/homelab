---
device_name: YHLD-FRWL1
human_name: YHLD Firewall 1
location: [[../racks/YHLR-SVRK1.md]]
subnet: ["10.1.1.0/24", "10.1.5.0/24", "10.1.10.0/24", "10.1.50.0/24", "10.13.13.0/24"]
tags: ["firewall", "networking", "security", "nixos"]
---

# YHLD Firewall 1

## Overview

NixOS VM (VMID 506) running on [[YHLD-SERV2/YHLD-SERV2.md|YHLD-SERV2]]. The firewall replaced OPNsense and is now the
single router, NAT gateway, DHCP authority, DNS entrypoint, and WireGuard client
for the homelab.

Config: [`hosts/firewall/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/firewall)

## Hardware (VM)

| /     | Value |
| ----- | ----- |
| VM    | QEMU/KVM, Standard PC (Q35 + ICH9, 2009) |
| vCPUs | 2 |
| RAM   | 2 GiB class |
| NICs  | 6× virtio, MAC-pinned with systemd `.link` files |
| OS    | NixOS 26.05 (Yarara), Linux 6.12.92 |

## NIC Layout

| NIC | Firewall name | MAC | Role |
| --- | ------------- | --- | ---- |
| `net0` | `wan0` | `bc:24:11:51:30:b7` | WAN DHCP client, NAT egress |
| `net1` | `lan1` | `bc:24:11:b4:ef:0d` | Trunk; untagged `br-phy`, tagged VLAN 10/50 |
| `net2` | `lan2` | `bc:24:11:cc:64:55` | Untagged `br-phy` member |
| `net3` | `lan3` | `bc:24:11:66:b5:b9` | Untagged `br-phy` member |
| `net4` | `sfp0` | `bc:24:11:37:82:fc` | Mac Studio direct link into `br-main` |
| `net5` | `sfp1` | `bc:24:11:96:2e:53` | Trunk; untagged `br-phy`, tagged VLAN 5/10/50 |

## Routed Segments

| Segment | Interface | Gateway | DHCP range | Purpose |
| ------- | --------- | ------- | ---------- | ------- |
| WAN | `wan0` | DHCP from ISP router | upstream | Internet uplink |
| Physical / fallback | `br-phy` | `10.1.1.1/24` | `10.1.1.100`–`10.1.1.250` | Untagged management |
| Infra / VLAN 5 | `sfp1.5` | `10.1.5.1/24` | `10.1.5.100`–`10.1.5.250` | Proxmox, BMC, VM/LXC management |
| Main / VLAN 10 | `br-main` | `10.1.10.1/24` | `10.1.10.100`–`10.1.10.250` | Trusted clients |
| IoT / VLAN 50 | `br-iot` | `10.1.50.1/24` | `10.1.50.100`–`10.1.50.250` | Untrusted devices |
| WireGuard | `wg0` | `10.13.13.2/32` | none | Site-to-site tunnel to VPS |

The cluster network (`10.0.7.0/24`) is a Proxmox-internal bridge. The firewall
has no live interface or route for it; Unbound only publishes selected static DNS
records into that range.

## Services

| Service | Listener / scope | Role |
| ------- | ---------------- | ---- |
| nftables | kernel | Default-drop input/forward, WAN masquerade, IoT isolation |
| Unbound | `0.0.0.0:53`, `[::]:53` | Client-facing recursive resolver |
| Dnsmasq | `0.0.0.0:67`, `0.0.0.0:53053` | DHCP + local DNS authority |
| Blocky | `127.0.0.1:5354`, HTTP `*:4000` | Ad-blocking DNS proxy |
| WireGuard | `wg0` | Outbound tunnel to VPS |
| Avahi | mDNS `5353` | Reflects mDNS between `br-main` and `sfp1.5` |
| Chrony | UDP `123` | NTP server for LAN/IoT |
| OpenSSH | TCP `22` | Key-only admin access; nftables limits exposed LANs |
| Prometheus / Grafana | TCP `9090` / `3000` | Firewall observability |
| Exporters | TCP `9100`, `9153`, `9167` | node, dnsmasq, and Unbound metrics |

## DNS Flow

```text
Clients → Unbound (:53)
            ├─ internal.yomitosh.media? → Dnsmasq (:53053)
            ├─ cluster/local zones?      → Unbound local-data
            └─ everything else?          → Blocky (:5354) → upstream
```

## WireGuard

```text
firewall  10.13.13.2  <-- wg -->  10.13.13.1  VPS (wireguard.yomitosh.media)
```

The firewall dials out to the VPS. Configured peer allowed IPs are
`10.13.13.0/24`; live state showed a recent handshake and MSS clamping is applied
in nftables.

## DHCP Reservations

| MAC | Hostname | IP | Segment |
| --- | -------- | -- | ------- |
| `bc:24:11:78:dc:ab` | `kloadbalancer` | `10.1.5.40` | Infra |
| `bc:24:11:24:10:3b` | `knode1` | `10.1.5.71` | Infra |
| `bc:24:11:34:e2:12` | `knode2` | `10.1.5.72` | Infra |
| `bc:24:11:3b:26:f1` | `knode3` | `10.1.5.73` | Infra |
| `bc:24:11:8b:0c:40` | `knode4` | `10.1.5.74` | Infra |
| `fc:ee:28:03:6c:d5` | `k1c` | `10.1.50.83` | IoT |
| `80:9d:65:5e:3a:34` | `x2d` | `10.1.50.114` | IoT |

Reservations are managed in
[`hosts/firewall/dhcp.nix`](https://github.com/abayomi185/nix-dotfiles/blob/main/hosts/firewall/dhcp.nix).

## Static DNS Records

| Name | Address |
| ---- | ------- |
| `firewall.internal.yomitosh.media` | `10.1.10.1` |
| `pve-firewall.internal.yomitosh.media` | `10.1.5.11` |
| `pve.internal.yomitosh.media` | `10.1.5.12` |
| `knode1.cluster.internal.yomitosh.media` | `10.0.7.41` |
| `knode2.cluster.internal.yomitosh.media` | `10.0.7.42` |
| `knode3.cluster.internal.yomitosh.media` | `10.0.7.43` |
| `network-share.cluster.internal.yomitosh.media` | `10.0.7.202` |
| `local.yomitosh.media` | `10.1.5.96` |


## Management

```bash
# Rebuild and switch from nix-dotfiles
nixos-rebuild switch --flake .#firewall --target-host root@firewall.internal.yomitosh.media

# Useful aliases on the firewall
fw-status        # nft list ruleset
fw-connections   # conntrack -L
dhcp-leases      # cat /var/lib/dnsmasq/dnsmasq.leases
```