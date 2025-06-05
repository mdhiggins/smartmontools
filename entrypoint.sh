#!/bin/sh

# Start syslogd in foreground, logging to stdout
syslogd -n -O /dev/stdout &

# Start smartd normally (daemonizes)
smartd

# Wait forever to keep container running
tail -f /dev/null
