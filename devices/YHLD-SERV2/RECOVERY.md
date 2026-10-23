# pve-firewall recovery

What to do when the network is down and the cause is likely
[[./YHLD-SERV2.md|YHLD-SERV2]] or the firewall VM on it.

## 1. Get in

When the firewall VM is down, VLAN 5 (`10.1.5.11`) and Wi-Fi via the firewall
are gone too.

- **Internet meanwhile:** join the ISP router network (`192.168.1.0/24`). The
  firewall's WAN shows up there as `192.168.1.185` with every port closed.
  That address only proves the VM is running.
- **Host shell:** plug a laptop into **Eth1** on the host, set a static
  `10.1.99.10/24` (no gateway), then:

  ```bash
  ssh root@10.1.99.2
  ```

- **Local console:** plug in a monitor and keyboard. See section 3 if it goes black.

## 2. Firewall VM looks hung

The console stopping at a boot line (e.g. after `wg-quick`) is usually just
the last thing it printed. Check what QEMU thinks:

```bash
qm status 506 --verbose | grep -E '^(status|qmpstatus)'
```

| `qmpstatus` | Meaning | Next |
| ----------- | ------- | ---- |
| `running` | Guest is up | Look inside the guest |
| `io-error` | Disk write failed, VM paused | Thin pool is full, see below |
| `paused` | Paused manually | `qm resume 506` |

### Thin pool full (`io-error`)

```bash
lvs -o lv_name,lv_size,data_percent pve      # data at 100%?
dmesg | grep -i 'out-of-data-space'
```

Free space, then resume:

1. Delete old snapshots (`qm listsnapshot <vmid>`, `qm delsnapshot <vmid> <name>`).
   A long-lived snapshot keeps every block changed since it was taken.
2. Trim inside the running guests (needs `discard=on` on the disk):

   ```bash
   qm guest exec 506 --timeout 300 -- /run/current-system/sw/bin/fstrim -av
   ```

   Trimming the firewall VM freed ~9G on 2026-10-23.
3. `qm resume 506`

Watch for it: `data` should stay well under 90%.

## 3. Host console goes black after login

That happens when a VM grabs the iGPU, which is the host's only display. Since
SR-IOV, knode4 uses VF `00:02.1` and the host should keep `00:02.0`. If the
screen still goes black:

- **Stop VMs auto-starting for one boot:** at GRUB press `e`, append to the `linux` line:

  ```text
  systemd.mask=pve-guests.service
  ```

  Start what you need by hand afterwards (`qm start 506`).
- **SR-IOV driver breaks boot:** append `module_blacklist=i915,xe` instead.
- knode4 also has `startup: up=300`, so you get ~5 minutes of console after boot
  before it starts.

Check what holds the GPU:

```bash
lspci -nnk -s 00:02
grep -H hostpci /etc/pve/qemu-server/*.conf
```

## 4. Host has no DNS

```bash
cat /etc/resolv.conf                       # 10.1.5.1 must be first
dig +short deb.debian.org @10.1.5.1
```

Fix through Proxmox so the change persists:

```bash
pvesh set /nodes/pve-firewall/dns --search internal.yomitosh.media --dns1 10.1.5.1 --dns2 10.1.1.1
```

## 5. After a Proxmox kernel update

The SR-IOV driver is an out-of-tree dkms module, so it has to rebuild for each kernel.

```bash
dkms status                                 # must say "installed" for the new kernel
proxmox-boot-tool kernel list               # pinned kernel
cat /sys/bus/pci/devices/0000:00:02.0/sriov_numvfs   # after reboot: 1
```

- Only unpin or move the pin once `dkms status` shows the new kernel as installed.
- When bumping the driver, update the `i915-sriov` tag in `nix-dotfiles` too
  and rebuild knode4.
- Driver releases list supported kernels; check before a major kernel jump.

### Roll back SR-IOV

```bash
dpkg -P i915-sriov-dkms
# /etc/default/grub: drop i915.enable_guc=3 i915.max_vfs=7 module_blacklist=xe
# /etc/sysfs.conf: drop the sriov_numvfs line
update-grub && update-initramfs -u
qm set 704 --hostpci0 0000:00:02     # whole iGPU again; host console goes black when 704 starts
```
