FROM docker.io/alpine:3.20

RUN apk add --no-cache \
	ca-certificates \
	openssh \
	git \
	ansible \
	make \
	just

ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools nc-dnsapi

ENV ANSIBLE_STDOUT_CALLBACK=unixy
ENV ANSIBLE_LOAD_CALLBACK_PLUGINS=1
ENV RECORDS="* @"
ENV SCHEDULE="*/10 * * * *"

WORKDIR /netcup-dns

COPY ansible ansible
COPY entrypoint.sh .
RUN chmod 777 entrypoint.sh

ENTRYPOINT [ "/netcup-dns/entrypoint.sh" ]
CMD [ "crond", "-f" ]
