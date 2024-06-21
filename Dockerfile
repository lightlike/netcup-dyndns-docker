FROM docker.io/alpine:3.20

RUN apk add --no-cache \
	ca-certificates \
	openssh \
	git \
	ansible \
	make \
	just \
	python3 \
	py3-pip

RUN pip install --no-cache --break-system-packages nc-dnsapi

# Ansible specific variables
ENV ANSIBLE_LOCALHOST_WARNING=False
ENV ANSIBLE_INVENTORY_UNPARSED_WARNING=False

# DynDNS Variables
ENV RECORDS="@ *"
ENV SCHEDULE="*/10 * * * *"

WORKDIR /netcup-dns

COPY ansible ansible
COPY entrypoint.sh .
RUN chmod 777 entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
CMD [ "crond", "-f" ]
