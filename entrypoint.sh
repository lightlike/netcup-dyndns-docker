#!/bin/sh
echo "${SCHEDULE} ansible-playbook /netcup-dns/update-dns.yaml" > /etc/crontabs/root
exec "$@"
