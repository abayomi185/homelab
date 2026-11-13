---
device_name: YHLD-AUIF1
human_name: YHLD Audio Interface 1
tags: ["audio", "usb", "sonamesh"]
---

# YHLD Audio Interface 1

## Hardware

| /          |                                     |
| ---------- | ----------------------------------- |
| Model      | Behringer UMC1820 USB audio interface |
| USB ID     | `1397:0503`                         |
| Attached to | [[./YHLD-SERV1/YHLD-SERV1.md\|YHLD-SERV1]], passed through to VM 301 `sonamesh` |

## Role

Analog I/O for SonaMesh. Input 1 (`AUX0`) is streamed to the Mac Studio, MacBook
and GameBox; their audio and AirPlay play back out of `AUX0`/`AUX1` (the speakers).
Routes live in [`hosts/sonamesh/`](https://github.com/abayomi185/nix-dotfiles/tree/main/hosts/sonamesh).

USB autosuspend is disabled in the VM so the interface stays available while idle.
