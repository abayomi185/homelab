---
device_name: YHLD-SERV1
human_name: YHLD Server 1
location: [[../racks/YHLR-SVRK1.md]]
subnet: ["10.0.1.0/24"]
tags: ["workstation", "mac"]
---

# YHLD Server 1

## Notes

```sh
# To see CPU frequency information on Linux:
cpupower frequency-info
```

Crontab has been set up as so:

```sh
# Set CPU governor to powersave on reboot
@reboot cpupower frequency-set -g powersave
# Set energy performance preference (AMD pstate) to "power" on reboot
@reboot /bin/bash -c 'echo "power" | tee /sys/devices/system/cpu/cpu*/cpufreq/en
ergy_performance_preference'
```

To check energy performance preference option:

```sh
cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_available_preferences
```
