# CONTEXT.md — Yomi's Homelab (YHL)

Core truths and editorial guidance. This file is intentionally short; detailed
inventory belongs in `devices/`, rack placement in `racks/`, and network facts in
`NETWORKING.md` / `network/vlan/`.

## Purpose

A two-hypervisor homelab providing:

- Routing, firewalling, DNS, DHCP, mDNS reflection, and WireGuard remote access.
- Kubernetes workloads managed with GitOps.
- Shared storage for Time Machine, media, Kubernetes persistent volumes, and NAS use.
- Compute experimentation for GPU/ML, audio streaming, and containerised workloads.

## Durable Architecture

- **Primary rack**: `YHLR-SVRK1`.
- **Hypervisors**: `YHLD-SERV1` (`pve`, main Proxmox VE host) and `YHLD-SERV2` (`pve-firewall`, standalone Proxmox VE host for the firewall, Home Assistant and `knode4`).
- **Firewall**: `YHLD-FRWL1`, a NixOS VM on `YHLD-SERV2`. It replaced OPNsense.
- **Cluster**: k3s on `knode1`–`knode4`; `knode1` is the server/init node.
- **Ingress**: `kloadbalancer.internal.yomitosh.media` / Traefik.
- **Storage**: `network-share.internal.yomitosh.media` LXC provides Samba, NFS, FTP, and Time Machine service.
- **Audio**: `l-audio-share.internal.yomitosh.media`.
- **ML**: `machine-learning.internal.yomitosh.media`; its NixOS flake entry is currently commented out, while Home Manager config remains active.

## Network Segments

| Segment | Interface | Gateway | Subnet | Purpose |
| --- | --- | --- | --- | --- |
| Physical / fallback | `br-phy` | `10.1.1.1` | `10.1.1.0/24` | Untagged physical management |
| Infra / VLAN 5 | `sfp1.5` | `10.1.5.1` | `10.1.5.0/24` | Proxmox, BMC, VM/LXC management |
| Main / VLAN 10 | `br-main` | `10.1.10.1` | `10.1.10.0/24` | Trusted clients and workstations |
| IoT / VLAN 50 | `br-iot` | `10.1.50.1` | `10.1.50.0/24` | IoT / untrusted devices |
| Cluster | Proxmox internal bridge | none on firewall | `10.0.7.0/24` | k3s and service backplane |
| WireGuard | `wg0` | VPS peer `10.13.13.1` | firewall `10.13.13.2/32` | Site-to-site tunnel |

The firewall has no interface on `10.0.7.0/24` and does not route the cluster
network. Only selected DNS records point at cluster addresses.

## DNS Architecture

```text
Clients → Unbound (:53)
            ├─ internal.yomitosh.media? → Dnsmasq (:53053)
            ├─ cluster/local zones?      → Unbound local-data
            └─ everything else?          → Blocky (:5354) → upstream
```

`Dnsmasq` is the DHCP authority for LAN segments. Static DHCP reservations double
as local DNS records under `internal.yomitosh.media`.

## Configuration Repositories

| Repo | Location | Purpose |
| --- | --- | --- |
| `homelab` | [github.com/abayomi185/homelab](https://github.com/abayomi185/homelab) | Human-readable inventory, topology, rack, and physical device docs |
| `nix-dotfiles` | [github.com/abayomi185/nix-dotfiles](https://github.com/abayomi185/nix-dotfiles) | Nix flakes for NixOS, nix-darwin, LXCs, firewall, VPS, and shared host config |
| `home-ops` | [github.com/abayomi185/home-ops](https://github.com/abayomi185/home-ops) | Flux CD / Kustomize Kubernetes application manifests |
| `nix-secrets` | private GitHub repo | SOPS/age-encrypted secrets consumed by `nix-dotfiles` and cluster workflows |

## Naming Conventions

- **YHL**: Yomi's Homelab.
- **YHLR**: Yomi's Homelab Rack.
- **YHLD**: Yomi's Homelab Device.
- Device suffixes use role abbreviation + sequence number, e.g. `FRWL1` = Firewall 1.
- Kubernetes nodes use `knodeN`.
- Internal DNS domain: `*.internal.yomitosh.media`.

## Editorial Rules

- Keep volatile DHCP lease state out of docs unless it is a configured static reservation.
- Prefer hostnames, subnets, roles, and source-of-truth config paths over transient IP observations.
- Put detailed device facts in `devices/`, VLAN details in `network/vlan/`, and rack placement in `racks/`.
- Never commit unencrypted secrets.
