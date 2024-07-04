#!/bin/sh

echo "Creating cronjob with schedule: ${SCHEDULE}"
echo "${SCHEDULE} ansible-playbook /netcup-dns/ansible/update-dns.yaml" > /etc/crontabs/root

echo "Running command: '$@'"
exec "$@"
