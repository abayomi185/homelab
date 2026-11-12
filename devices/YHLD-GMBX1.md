---
device_name: YHLD-GMBX1
human_name: YHLD GameBox 1
location: [[../racks/YHLR-SVRK1.md]]
subnet: ["10.1.10.0/24"]
tags: ["gaming", "pc", "windows"]
---

# YHLD GameBox 1

## Hardware

| /           |                                                   |
| ----------- | ------------------------------------------------- |
| CPU         | AMD Ryzen 5 5500X3D (AM4)                         |
| Motherboard | Gigabyte B550I AORUS PRO AX (Mini-ITX)            |
| RAM         | 32 GB (2 × 16 GB DDR4-3600)                       |
| Storage     | 1 TB Kingston NV3 NVMe + 250 GB Kingston A2000 NVMe |
| GPU         | Nvidia GeForce RTX 5060                           |
| NIC         | Realtek 2.5GbE (wired); Intel AX210 Wi-Fi 6E      |

## Software

| /   |                |
| --- | -------------- |
| OS  | Windows 11 Pro |

## Access

- SSH (OpenSSH for Windows): `yomigames@gamebox.internal.yomitosh.media`
- Not always online; failed SonaMesh `gamebox` routes are expected.

## Network

| /        |                    |
| -------- | ------------------ |
| Hostname | `GameBox`          |
| Segment  | Main LAN / VLAN 10 |
| Subnet   | `10.1.10.0/24`     |
