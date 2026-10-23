---
device_name: YHLD-SERV2
human_name: YHLD Server 2
location: [[../../racks/YHLR-SVRK1.md]]
subnet: ["10.1.5.0/24", "10.1.99.0/24"]
tags: ["server", "hypervisor", "proxmox", "intel-n150"]
---

# YHLD Server 2

Standalone Proxmox VE node `pve-firewall` (not clustered with
[[../YHLD-SERV1/YHLD-SERV1.md|YHLD-SERV1]]). It hosts the firewall VM, so when
this box has a problem the whole network usually does too.

## Hardware

| /       | Value |
| ------- | ----- |
| CPU     | Intel N150 (Alder Lake-N), iGPU `00:02.0` |
| Storage | NVMe, LVM `pve`: `root` 20G, `data` thin pool ~89G (`local-lvm`) |
| Kernel  | Pinned `7.0.14-25-pve` (`proxmox-boot-tool kernel list`) |

## Network

| Bridge | Port | Address | Use |
| ------ | ---- | ------- | --- |
| `vmbr0` | Eth0 `enp2s0` | none (IPv6 SLAAC only) | Firewall WAN, to ISP router |
| `vmbr1` | Eth1 `enp3s0` | `10.1.99.2/24` | **Out-of-band access**, works with the firewall down |
| `vmbr2`–`vmbr4` | Eth2, Eth3, SFP0 | none | Firewall LAN ports |
| `vmbr5` / `vmbr5.5` | SFP1 | `10.1.5.11/24`, gw `10.1.5.1` | Management on VLAN 5 (via firewall) |

Host DNS: `10.1.5.1` primary, `10.1.1.1` secondary. The firewall does not answer
UDP DNS on `10.1.1.1` from VLAN 5, so `10.1.5.1` must stay first.

## Virtual Machines

| VMID | Name | Notes |
| ---- | ---- | ----- |
| 506 | `firewall` | [[../YHLD-FRWL1.md\|YHLD-FRWL1]], `onboot` |
| 306 | `home-assistant` | `onboot`, startup order 2 |
| 704 | `knode4` | k3s GPU node, iGPU SR-IOV VF `00:02.1` |

All VM disks use `discard=on`. The thin pool is close to fully provisioned
(24G + 32G + 32G), so keep an eye on `lvs` Data%.

## iGPU SR-IOV

knode4 gets a virtual function of the iGPU instead of the whole device, so the
host keeps its console.

- Driver: [`strongtz/i915-sriov-dkms`](https://github.com/strongtz/i915-sriov-dkms)
  `2026.09.16` `.deb` (dkms). Guest side uses the same tag as a flake input in
  `nix-dotfiles` (`i915-sriov`).
- Kernel args (`/etc/default/grub`):
  `intel_iommu=on iommu=pt i915.enable_guc=3 i915.max_vfs=7 module_blacklist=xe`
- VF count: `/etc/sysfs.conf` → `devices/pci0000:00/0000:00:02.0/sriov_numvfs = 1`
- Never pass `00:02.0` (the PF) to a VM. Only VFs `00:02.1`+.

## Operations

- [Recovery runbook](./RECOVERY.md)
