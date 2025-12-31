FROM ghcr.io/ptero-eggs/yolks:wine_latest

LABEL author="struppi" maintainer="https://github.com/struppinet"

# customization
VOLUME ["/home/container/server_files"]

# well that fixed location sucks
RUN mkdir -p "/home/container/.wine/drive_c/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server"
VOLUME ["/home/container/.wine/drive_c/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server"]

ADD ./files /home/container//scripts
RUN chmod +x /home/container//scripts/*.sh

HEALTHCHECK CMD ! grep -q "Uploading Crash Report" /tmp/app.stdout || exit 1

ENTRYPOINT ["/bin/bash", "/home/container/scripts/entrypoint.sh"]
CMD ["/home/container/scripts/start.sh"]
