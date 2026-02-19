# Netcup DynDNS API Job using Ansible

[![GitHub Release](https://img.shields.io/github/v/release/lightlike/netcup-dyndns-docker)](https://github.com/lightlike/netcup-dyndns-docker/releases/latest)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/lightlike/netcup-dyndns-docker/docker-publish.yml?logo=github)](https://github.com/lightlike/netcup-dyndns-docker/actions/workflows/docker-publish.yml)

## Summary

This container uses cron and ansible to periodically set dns entries for the current device.

> This is meant to be a (mostly) drop-in replacement for [b2un0/docker-netcup-dyndns](https://github.com/b2un0/docker-netcup-dyndns)
> You should just need to change `MODE` to `RECORDS` and the value from `both` to `@ *`.

This in itself does the same as the original but come with the folling improvements:
- fallback identity server when the original is down
- creates the domain entries automatically
- can set other subdomains than just `@` and `*`

## Setup

### Docker

```yaml
version: '2'
services:
    netcup-dyndns:
        container_name: netcup-dyndns
        environment:
            SCHEDULE: "*/10 * * * *"
            DOMAIN: "example.com"
            RECORDS: "@ *"
            IPv4: "yes"
            IPv6: "yes"
            CUSTOMER_ID: ${CUSTOMER_ID}
            API_KEY: ${API_KEY}
            API_PASSWORD: ${API_PASSWORD}
            TZ: "Europe/Berlin"
        restart: unless-stopped
        image: ghcr.io/lightlike/netcup-dyndns:latest
```

### Without Docker

This container only executes the ansible playbook as a cronjob.
Any dependencies can be found inside the `Dockerfile` so this can be executed without the container.

This is not supported and you have to know how to work with ansible.

## Variables

| Variable     | Function |
|:------------:|:-------- |
| SCHEDULE     | Cron schedule for executing ansible playbook<br>default: every 10 minutes<br>time between executions can be reduced but try not to reduce it to much.
| DOMAIN       | The domain the values should be set to
| RECORDS      | Subdomains the IPs should be set to (separated by space)<br>default: `@` and `*`
| IPv4         | if IPv4 should be set<br>default: no
| IPv6         | if IPv6 should be set<br>default: no
| CUSTOMER_ID  | netcup customer id
| API_KEY      | netcup API key
| API_PASSWORD | netcup API password

## Funtionality

This container uses http://ident.me/ and http://tnedi.me/ to get the current IP of the Server and sets that as in netcup.
The Documentation for these sites can be found under: https://api.ident.me/ and https://api.tnedi.me/
These Websites are located in Germany if that may couse trouble for you.

### IPv6

Docker by default does not support outgoing requests using IPv6.
IPv6 can be enabled like so:
```yaml
version: '2'
services:
    netcup-dyndns:
        container_name: netcup-dyndns
        networks:
          - default
        environment:
            ...
        restart: unless-stopped
        image: ghcr.io/lightlike/netcup-dyndns:latest
networks:
  default:
    enable_ipv6: true
```
That should not cause any problems as this container does not expose any ports.

### Replacing the current logic

The current ansible logic can be replaced by replacing the `update-dns.yaml`.
This can be done by mounting a new file from the host system to the container.
```yaml
version: '2'
services:
    netcup-dyndns:
        container_name: netcup-dyndns
        environment:
            ...
        volumes:
            - /path/to/new/yaml:/netcup-dns/ansible/update-dns.yaml:ro
        restart: unless-stopped
        image: ghcr.io/lightlike/netcup-dyndns:latest
```
