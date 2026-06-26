# Untagged — Physical / fallback

| / | Value |
| --- | --- |
| Firewall interface | `br-phy` |
| Gateway / DNS | `10.1.1.1` |
| Subnet | `10.1.1.0/24` |
| DHCP range | `10.1.1.100`–`10.1.1.250` |
| Lease time | 4h |
| Purpose | Untagged physical management and fallback access |

Bridge members: `lan1`, `lan2`, `lan3`, and `sfp1` are untagged into `br-phy`.
