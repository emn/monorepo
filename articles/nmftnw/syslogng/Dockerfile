# syntax=docker/dockerfile:1
FROM balabit/syslog-ng:4.1.1

RUN apt-get update -qq && apt-get install -y cron && rm -rf /var/lib/apt/lists/*

COPY ./cisco_plugin.conf /usr/share/syslog-ng/include/scl/cisco/plugin.conf

# Ensure that this file is owned by root and has 644 permissions
COPY ./logcleanup /etc/cron.d/

COPY ./entry.sh /
RUN chmod +x /entry.sh

COPY ./syslog-ng.conf /etc/syslog-ng/syslog-ng.conf

ENTRYPOINT ["/entry.sh"]
