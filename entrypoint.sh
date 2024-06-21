#!/bin/sh
echo "${SCHEDULE} ansible-playbook /netcup-dns/ansible/update-dns.yaml" > /etc/crontabs/root
exec "$@"
