FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-ombi"

RUN apt-get update && \
	apt-get -y install --no-install-recommends mediainfo && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/ombi"
ENV SONARR_REL="latest"
ENV START_PARAMS=""
ENV UMASK=0000
ENV DATA_PERM=770
ENV UID=99
ENV GID=100
ENV USER="ombi"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

EXPOSE 5000

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]