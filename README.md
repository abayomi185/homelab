# Yomi's Homelab (YHL)

Stable context for the homelab: what exists, where it is, how it connects, and
why. Configuration lives in the repos below and is the source of truth; these
docs don't repeat it.

## Index

| Document | Purpose |
| --- | --- |
| [NETWORKING.md](./NETWORKING.md) | Segments, physical topology, network devices |
| [POWER.md](./POWER.md) | Power |
| [devices/](./devices/) | Per-device notes (YHLD-*) |
| [racks/](./racks/) | Rack notes (YHLR-*) |

## Architecture

- **Rack**: `YHLR-SVRK1`.
- **Hypervisors**: `YHLD-SERV1` (`pve`, main Proxmox host) and `YHLD-SERV2` (`pve-firewall`, standalone Proxmox host for the firewall, Home Assistant and `knode4`).
- **Firewall**: `YHLD-FRWL1`, NixOS VM on `YHLD-SERV2`. Router, DHCP, DNS, WireGuard, UniFi controller. Replaced OPNsense.
- **Cluster**: k3s on `knode1`–`knode4`; `knode1` is the server/init node.
- **VPS**: `YHLD-VPSR1`, off-site. WireGuard hub and public k3s ingress.
- **Audio**: `sonamesh` VM on `YHLD-SERV1` with the `YHLD-UMC1` interface.
- **Storage**: `network-share` LXC (Samba, NFS, FTP, Time Machine).

## Repositories

| Repo | Purpose |
| --- | --- |
| [`nix-dotfiles`](https://github.com/abayomi185/nix-dotfiles) | NixOS/nix-darwin/LXC/firewall config. Source of truth for network config |
| [`home-ops`](https://github.com/abayomi185/home-ops) | Flux CD Kubernetes manifests |
| `nix-secrets` (private) | SOPS/age secrets for the above |

## Naming

- **YHLR** rack, **YHLD** device. Suffix = role + sequence, e.g. `FRWL1`.
- Kubernetes nodes: `knodeN`. Internal domain: `*.internal.yomitosh.media`.
- Retired devices keep their doc with `status: decommissioned` in frontmatter.

## Editorial Rules

- Record stable facts config can't hold: hardware, physical location and cabling, roles, why things are set up as they are.
- Don't copy config (IPs, DHCP ranges, reservations, interface names, ports). Link to it.
- Never commit unencrypted secrets.
