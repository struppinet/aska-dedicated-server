FROM ghcr.io/ptero-eggs/yolks:wine_latest

LABEL author="struppi" maintainer="https://github.com/struppinet"

# customization
VOLUME ["/srv/aska_server_files"]

# well that fixed location sucks
RUN mkdir -p "/home/container/.wine/drive_c/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server"
VOLUME ["/home/container/.wine/drive_c/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server"]

ADD ./files /srv/scripts
RUN chmod +x /srv/scripts/*.sh

ENTRYPOINT ["/bin/bash", "/srv/scripts/entrypoint.sh"]
CMD ["/srv/scripts/start.sh"]
