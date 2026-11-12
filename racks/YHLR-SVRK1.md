---
device_name: YHLR-SVRK1
human_name: YHLR Server Rack 1
tags: ["server-rack", "YHLR", "rack"]
---

# YHLR Server Rack 1

| Device | Role | Stable network facts |
| ------ | ---- | -------------------- |
| [[../devices/YHLD-SERV1/YHLD-SERV1.md\|YHLD-SERV1]] | Proxmox hypervisor | hostname `pve` |
| [[../devices/YHLD-SERV2/YHLD-SERV2.md\|YHLD-SERV2]] | Proxmox host for firewall VM | hostname `pve-firewall`; OOB `10.1.99.2` |
| [[../devices/YHLD-FRWL1.md\|YHLD-FRWL1]] | Firewall VM on Proxmox | hostname `firewall`; LAN gateways + WireGuard |
| [[../devices/YHLD-SWCH2/YHLD-SWCH2.md\|YHLD-SWCH2]] | Core switch (UniFi) | hostname `yhld-swch2` |
| [[../devices/YHLD-ACPT2/YHLD-ACPT2.md\|YHLD-ACPT2]] | WiFi access point (UniFi) | hostname `yhld-acpt2`; PoE from SWCH2 |
| [[../devices/YHLD-MSDO1.md\|YHLD-MSDO1]] | Mac Studio workstation | flake `Mac-Studio` |
| [[../devices/YHLD-GMBX1.md\|YHLD-GMBX1]] | Gaming PC | FQDN `GameBox.internal.yomitosh.media` |
| [[../devices/YHLD-IPMI1.md\|YHLD-IPMI1]] | BMC for SERV1 | FQDN `supermicro-ipmi.internal.yomitosh.media` |
| [[../devices/YHLD-K1C1.md\|YHLD-K1C1]] | Creality K1C 3D printer | hostname `k1c` |
| [[../devices/YHLD-3DPR1.md\|YHLD-3DPR1]] | Bambu Lab X2D 3D printer | hostname `x2d` |
| [[../devices/YHLD-SLZB1.md\|YHLD-SLZB1]] | Zigbee coordinator | hostname `SLZB-MR2` |
