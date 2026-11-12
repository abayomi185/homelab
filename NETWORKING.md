# Networking

[[./devices/YHLD-FRWL1.md|YHLD-FRWL1]] is the single gateway, router, DHCP and
DNS server. Config: [`hosts/firewall/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/firewall).

## Segments

Native, Infra, Main, Guest and IoT gateways are `.1` on the firewall.

| Segment | Subnet | Purpose |
| --- | --- | --- |
| Native (untagged) | `10.1.1.0/24` | Fallback management |
| Infra (VLAN 5) | `10.1.5.0/24` | Proxmox, BMCs, switch/AP, k8s/LXC management |
| Main (VLAN 10) | `10.1.10.0/24` | Workstations, trusted clients |
| Guest (VLAN 20) | `10.1.20.0/24` | Guest WiFi; internet only |
| IoT (VLAN 50) | `10.1.50.0/24` | IoT; internet only, no trusted LANs |
| Cluster | `10.0.7.0/24` | k3s backplane; Proxmox-internal, not routed by firewall |
| WireGuard | `10.13.13.0/24` | Site-to-site tunnel to VPS (`10.13.13.1`) |
| OOB | `10.1.99.0/24` | Direct link to YHLD-SERV2, works with firewall down |

## Physical Topology

```text
ISP router ── SERV2 Eth0 ── firewall WAN
               SERV2 SFP1 ══ SWCH2 port 25 (trunk)
                               ├─ port 26 ══ SERV1
                               ├─ port 11 ── IPMI1
                               ├─ port 7 ─── SLZB1
                               └─ port 1 ─── ACPT2 (PoE)
               SERV2 SFP0 ── Mac Studio (Main)
               SERV2 Eth3 ── GameBox (Main)
               SERV2 Eth1 ── OOB access
```

## UniFi

SWCH2 and ACPT2 are adopted by UniFi OS Server, running in a container on the
firewall. UI: `https://10.1.5.1:11443`. Device settings (port profiles, WLANs)
live in the controller, not in Nix.

## Devices

| Device | Role |
| --- | --- |
| [[./devices/YHLD-FRWL1.md\|YHLD-FRWL1]] | Firewall VM |
| [[./devices/YHLD-SERV1/YHLD-SERV1.md\|YHLD-SERV1]] | Proxmox hypervisor (`pve`) |
| [[./devices/YHLD-SERV2/YHLD-SERV2.md\|YHLD-SERV2]] | Proxmox host for firewall (`pve-firewall`) |
| [[./devices/YHLD-IPMI1.md\|YHLD-IPMI1]] | BMC for SERV1 |
| [[./devices/YHLD-SWCH2/YHLD-SWCH2.md\|YHLD-SWCH2]] | Core switch (UniFi) |
| [[./devices/YHLD-ACPT2/YHLD-ACPT2.md\|YHLD-ACPT2]] | WiFi AP (UniFi) |
| [[./devices/YHLD-MSDO1.md\|YHLD-MSDO1]] | Mac Studio (Main) |
| [[./devices/YHLD-MBP14.md\|YHLD-MBP14]] | MacBook Pro 14 (Main) |
| [[./devices/YHLD-GMBX1.md\|YHLD-GMBX1]] | GameBox gaming PC (Main) |
| [[./devices/YHLD-WRPT1.md\|YHLD-WRPT1]] | WiFi repeater |
| [[./devices/YHLD-K1C1.md\|YHLD-K1C1]] | Creality K1C 3D printer (IoT) |
| [[./devices/YHLD-3DPR1.md\|YHLD-3DPR1]] | Bambu Lab X2D 3D printer (IoT) |
| [[./devices/YHLD-SLZB1.md\|YHLD-SLZB1]] | Zigbee coordinator (IoT) |
| [[./devices/YHLD-DKFN1.md\|YHLD-DKFN1]] | Desk fan (IoT) |
| [[./devices/YHLD-VPSR1.md\|YHLD-VPSR1]] | Off-site VPS: WireGuard hub, public k3s ingress |

## DNS

Clients → Unbound on the firewall. `internal.yomitosh.media` goes to Dnsmasq
(DHCP hostnames + static records); everything else goes through Blocky
(ad-blocking) to upstream.
