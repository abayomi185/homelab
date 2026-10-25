# Yomi's Homelab Networking

The firewall ([[./devices/YHLD-FRWL1.md|YHLD-FRWL1]]) is the single gateway,
router, DHCP server, and DNS entrypoint for the LAN. Source configuration lives in
[`hosts/firewall/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/firewall); live state was checked on
`firewall.internal.yomitosh.media`.

## Segments

| Segment             | Interface               | Gateway               | Subnet                   | DHCP range                  | Purpose                                             |
| ------------------- | ----------------------- | --------------------- | ------------------------ | --------------------------- | --------------------------------------------------- |
| WAN                 | `wan0`                  | ISP router            | DHCP                     | ISP DHCP                    | Internet uplink / NAT egress                        |
| Physical / fallback | `br-phy`                | `10.1.1.1`            | `10.1.1.0/24`            | `10.1.1.100`–`10.1.1.250`   | Untagged physical management                        |
| Infra (VLAN 5)      | `sfp1.5`                | `10.1.5.1`            | `10.1.5.0/24`            | `10.1.5.100`–`10.1.5.250`   | Proxmox, BMCs, k8s/LXC management                   |
| Main (VLAN 10)      | `br-main`               | `10.1.10.1`           | `10.1.10.0/24`           | `10.1.10.100`–`10.1.10.250` | Workstations, trusted clients, switch/AP management |
| IoT (VLAN 50)       | `br-iot`                | `10.1.50.1`           | `10.1.50.0/24`           | `10.1.50.100`–`10.1.50.250` | IoT / untrusted devices                             |
| Cluster             | Proxmox internal bridge | none on firewall      | `10.0.7.0/24`            | static per VM/LXC           | k3s and service backplane; not routed by firewall   |
| WireGuard           | `wg0`                   | VPS peer `10.13.13.1` | firewall `10.13.13.2/32` | none                        | Site-to-site tunnel via VPS                         |

VLAN 10 and VLAN 50 are bridged across both trunk NICs (`sfp1` and `lan1`).
`sfp0` is an untagged member of `br-main` for the Mac Studio direct link. The
firewall has no live interface or route for `10.0.7.0/24`; only DNS records point
at cluster addresses.

## Devices

| Device                                             | Role                   | Stable network facts                                                                                    |
| -------------------------------------------------- | ---------------------- | ------------------------------------------------------------------------------------------------------- |
| [[./devices/YHLD-FRWL1.md\|YHLD-FRWL1]]            | NixOS firewall VM      | Hostname `firewall`; LAN gateways; WireGuard `10.13.13.2/32`                                            |
| [[./devices/YHLD-SERV1/YHLD-SERV1.md\|YHLD-SERV1]] | Proxmox hypervisor     | FQDN `pve.internal.yomitosh.media`; infra subnet `10.1.5.0/24`                                          |
| [[./devices/YHLD-SERV2/YHLD-SERV2.md\|YHLD-SERV2]] | Proxmox host (firewall) | FQDN `pve-firewall.internal.yomitosh.media`; infra subnet `10.1.5.0/24`; OOB `10.1.99.2`                |
| [[./devices/YHLD-IPMI1.md\|YHLD-IPMI1]]            | BMC for SERV1          | FQDN `supermicro-ipmi.internal.yomitosh.media`; infra subnet `10.1.5.0/24`                              |
| [[./devices/YHLD-SWCH1/YHLD-SWCH1.md\|YHLD-SWCH1]] | Core switch            | Hostname `MikroTik_Switch`; main subnet `10.1.10.0/24`                                                  |
| [[./devices/YHLD-ACPT1/YHLD-ACPT.md\|YHLD-ACPT1]]  | WiFi access point      | Hostname `MikroTik`; main/IoT WLANs                                                                     |
| [[./devices/YHLD-MSDO1.md\|YHLD-MSDO1]]            | Mac Studio workstation | Nix-darwin host `Mac-Studio`; main subnet `10.1.10.0/24`                                                |
| [[./devices/YHLD-MBP14.md\|YHLD-MBP14]]            | MacBook Pro 14         | Nix-darwin host `MacBook-Pro-14`; main subnet `10.1.10.0/24`                                            |
| [[./devices/YHLD-GMBX1.md\|YHLD-GMBX1]]            | GameBox gaming PC      | FQDN `GameBox.internal.yomitosh.media`; main subnet `10.1.10.0/24`                                      |
| [[./devices/YHLD-WRPT1.md\|YHLD-WRPT1]]            | WiFi repeater          | FQDN `wifi-repeater.internal.yomitosh.media`; upstream DHCP, downstream `192.168.50.0/24`               |
| [[./devices/YHLD-K1C1.md\|YHLD-K1C1]]              | Bambu Lab K1C printer  | Hostname `k1c`; IoT subnet `10.1.50.0/24`                                                               |
| [[./devices/YHLD-X2D1.md\|YHLD-X2D1]]              | IoT device             | Hostname `x2d`; IoT subnet `10.1.50.0/24`                                                               |
| [[./devices/YHLD-SLZB1.md\|YHLD-SLZB1]]            | Zigbee coordinator     | Hostname `SLZB-MR2`; IoT subnet `10.1.50.0/24`                                                          |
| [[./devices/YHLD-DKFN1.md\|YHLD-DKFN1]]            | IoT desk fan           | Hostname `yhld-dkfn1`; IoT subnet `10.1.50.0/24`                                                        |

## DNS and DHCP

Clients query Unbound on the firewall (`:53`). Unbound forwards
`internal.yomitosh.media` and reverse zones to Dnsmasq (`127.0.0.1:53053`);
everything else goes through Blocky (`127.0.0.1:5354`) before upstream DNS.

Static DHCP reservations currently configured on the firewall:

| Hostname | IP            | MAC                 | Segment |
| -------- | ------------- | ------------------- | ------- |
| `knode1` | `10.1.5.71`   | `bc:24:11:24:10:3b` | Infra   |
| `knode2` | `10.1.5.72`   | `bc:24:11:34:e2:12` | Infra   |
| `knode3` | `10.1.5.73`   | `bc:24:11:3b:26:f1` | Infra   |
| `knode4` | `10.1.5.74`   | `bc:24:11:8b:0c:40` | Infra   |
| `x2d`    | `10.1.50.114` | `80:9d:65:5e:3a:34` | IoT     |

Static DNS records currently configured on the firewall:

| Name                                            | Address      |
| ----------------------------------------------- | ------------ |
| `firewall.internal.yomitosh.media`              | `10.1.10.1`  |
| `pve-firewall.internal.yomitosh.media`          | `10.1.5.11`  |
| `pve.internal.yomitosh.media`                   | `10.1.5.12`  |
| `knode1.cluster.internal.yomitosh.media`        | `10.0.7.41`  |
| `knode2.cluster.internal.yomitosh.media`        | `10.0.7.42`  |
| `knode3.cluster.internal.yomitosh.media`        | `10.0.7.43`  |
| `network-share.cluster.internal.yomitosh.media` | `10.0.7.202` |
| `local.yomitosh.media`                          | `10.1.5.96`  |
