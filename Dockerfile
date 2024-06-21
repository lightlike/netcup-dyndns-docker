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
