# smartmontools Docker Container

A lightweight Docker container for `smartd`, the SMART disk monitoring daemon from the `smartmontools` package. This container supports monitoring both SATA and NVMe devices, sending email alerts, and running scheduled self-tests.

---

## 📦 Features

* Runs `smartd` in the foreground for container compatibility
* Supports monitoring of multiple disks including NVMe
* Sends email alerts on disk health changes or failures
* Configurable scheduling for short/long self-tests
* Supports `ssmtp` for simple email relay

---

## 🛠 Configuration

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
* `-W` = temperature thresholds (informational, warning, critical)
* `-m` = email address for alerts
* `-M daily` = sends a status report every day
* `-H` = monitor SMART health status

### `ssmtp.conf`

Sample:

```conf
root=you@gmail.com
mailhub=smtp.gmail.com:587
AuthUser=you@gmail.com
AuthPass=your_app_password
UseTLS=YES
UseSTARTTLS=YES
hostname=your-hostname
```

> 💡 You must generate an [App Password](https://support.google.com/accounts/answer/185833?hl=en) if you're using Gmail with 2FA.

---

## 🐳 Docker Compose

```yaml
version: '3.8'
services:
  smartmontools:
    image: yourusername/smartmontools
    container_name: smartmontools
    restart: unless-stopped
    privileged: true
    volumes:
      - /opt/appdata/smartmontools/smartd.conf:/etc/smartd.conf
      - /opt/appdata/smartmontools/ssmtp.conf:/etc/ssmtp/ssmtp.conf
      - /dev:/dev
    environment:
      - TZ=America/New_York
```

* `privileged: true`: required for access to `/dev` and SMART attributes
* `TZ`: sets correct timezone inside container

---

## 📧 Email Setup Notes

* **Test email** is sent at startup using `-M test`
* **Daily report** requires `-M daily` and proper scheduling via `-s`
* Ensure system time and container time are aligned

---

## 🔍 Troubleshooting

* No daily emails? Make sure `smartd` is **not** running with `--debug`.
* No logs? Mount a log directory or check if `smartd` is running in normal mode.
* `smartctl -l selftest /dev/sdX` will show test history for confirmation.

---

## 🧪 Development / Manual Run

```bash
docker run --rm -it --privileged
```
