FROM docker.io/alpine:3.20

RUN apk add --no-cache \
	ca-certificates \
	openssh \
	git \
	ansible \
	make \
	just \
	py3-dnspython \
	py3-passlib

ENV ANSIBLE_STDOUT_CALLBACK=unixy
ENV ANSIBLE_LOAD_CALLBACK_PLUGINS=1
ENV RECORDS="* @"
ENV SCHEDULE="*/10 * * * *"

WORKDIR /netcup-dns

COPY ansible/update-dns.yaml ansible
COPY entrypoint.sh .
RUN chmod 777 entrypoint.sh

ENTRYPOINT [ "/netcup-dns/entrypoint.sh" ]
CMD [ "crond", "-f" ]
