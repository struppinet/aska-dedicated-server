FROM ghcr.io/ptero-eggs/yolks:wine_latest as base

LABEL author="struppi" maintainer="https://github.com/struppinet"

# customization
VOLUME ["/srv/aska_server_files"]

ADD ./files /srv/scripts
RUN chmod +x /srv/scripts/*.sh

ENTRYPOINT ["/bin/bash", "/srv/scripts/entrypoint.sh"]
CMD ["/srv/scripts/start.sh"]
