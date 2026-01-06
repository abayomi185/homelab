# TODO

- [x] OPNSense does not route traffic for hosts that do not have a valid DHCP lease
  - Will go with DHCP for all hosts
- [x] Configure SuperMicro IPMI fan thresholds using ipmitool

  ```bash
  ipmitool sensor list all

  # Lower Non-Recoverable
  # Lower Critical
  # Lower Non-Critical
  # Upper Non-Critical
  # Upper Critical
  # Upper Non-Recoverable

  ipmitool sensor thresh "FAN4" lower 200 300 400
  ```
