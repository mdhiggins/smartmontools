# smartmontools Docker Container

A lightweight Docker container for `smartd`, the SMART disk monitoring daemon from the `smartmontools` package. This container supports monitoring both SATA and NVMe devices, sending email alerts, and running scheduled self-tests.

## Features

* Runs `smartd` in the foreground for container compatibility
* Supports monitoring of multiple disks including NVMe
* Sends email alerts on disk health changes or failures
* Configurable scheduling for short/long self-tests
* Uses `msmtp` for email relay

## Configuration

The container expects two main configuration files:

### `smartd.conf`

Sample:

```conf
DEFAULT -a -s (S/../../7/13|L/../15/./15) -W 0,0,46 -m your@email.com -M daily -H
/dev/sda
/dev/sdb
/dev/sdc

DEFAULT -a -s (S/../../7/13|L/../15/./15) -W 0,0,70 -m your@email.com -M daily -H
/dev/nvme0
```

* `-a`: enables all default SMART checks.
* `-s`: schedules tests:

  * `S` = short test every 7th day at 13:00
  * `L` = long test every 15th day at 15:00
* `-W` = temperature thresholds (diff, info, crit)
* `-m` = email address for alerts
* `-M daily` = sends a status report every day
* `-H` = monitor SMART health status

[smartd.conf documentation](https://linux.die.net/man/5/smartd.conf)

### `/etc/msmtprc`

Sample:

```conf
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        /var/log/msmtp.log

# Gmail SMTP configuration
account        mail
host           smtp.gmail.com
port           587
from           your.email@gmail.com
user           your.email@gmail.com
password       your-app-password

# Set default account
account default : mail
```

> You must generate an [App Password](https://support.google.com/accounts/answer/185833?hl=en) if you're using Gmail with 2FA.


### Confirm Scheduling!

run `docker exec smartmontools smartd -q showtests` and confirm your testing schedule shows upt

```
Next scheduled self tests (at most 5 of each type per device):
Device: /dev/sda [SAT], will do test 1 of type S at Sun Jun  8 04:27:51 2025 EDT
Device: /dev/sdb [SAT], will do test 1 of type S at Sun Jun  8 04:27:51 2025 EDT
Device: /dev/sdc [SAT], will do test 1 of type S at Sun Jun  8 04:27:51 2025 EDT
Device: /dev/nvme0, will do test 1 of type S at Sun Jun  8 04:27:51 2025 EDT
```

## Docker Compose

```yaml
version: '3.8'
services:
  smartmontools:
    image: yourusername/smartmontools
    container_name: smartmontools
    restart: unless-stopped
    privileged: true
    volumes:
      - /opt/appdata/smartmontools/smartd.conf:/etc/smartd.conf:ro
      - /opt/appdata/smartmontools/msmtprc:/etc/msmtprc:ro
      - /dev:/dev
    environment:
      - TZ=America/New_York
```

* `privileged: true`: required for access to `/dev` and SMART attributes
* `TZ`: sets correct timezone inside container

## Email Setup Notes

* **Test email** is sent at startup using `-M test`
* **Daily report** requires `-M daily` and proper scheduling via `-s` and are only sent if an error is detected
* Ensure system time and container time are aligned using the TZ variable

## Troubleshooting

* `smartctl -l selftest /dev/sdX` will show test history for confirmation.
