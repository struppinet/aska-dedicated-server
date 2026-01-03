FROM        debian:trixie-slim

ENV         DEBIAN_FRONTEND=noninteractive

ENV         USER=container
ENV         HOME=/home/container
WORKDIR		/home/container

STOPSIGNAL	SIGINT

RUN         dpkg --add-architecture i386 \
            # Update base packages
            && apt-get update \
	        && apt-get upgrade -y \
            # Install additional packages
	        && apt-get install -y --no-install-recommends \
            ca-certificates \
            cabextract \
            curl \
            locales \
            tar \
            wget \
            # Install required packages for wine
            winbind \
            xvfb \
            # Generate locale
            && sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
            && locale-gen \
            && update-locale LANG=en_US.UTF-8 \
            # Add sources for wine
            && mkdir -pm755 /etc/apt/keyrings \
            && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
            && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources \
            && apt-get update \
            # Install wine and with recommends
            && apt install --install-recommends winehq-stable -y \
            # Set up Winetricks
            && wget -q -O /usr/sbin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
            && chmod +x /usr/sbin/winetricks \
            # Deep Clean: Remove man pages, docs, and apt cache
            && rm -rf /usr/share/doc/* /usr/share/man/* /usr/share/info/* \
            && apt clean \
            && apt autoremove -y \
            && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV         HOME=/home/container
ENV         WINEPREFIX=/home/container/.wine
ENV         WINEDLLOVERRIDES="mscoree,mshtml="
ENV         DISPLAY=:0
ENV         DISPLAY_WIDTH=1024
ENV         DISPLAY_HEIGHT=768
ENV         DISPLAY_DEPTH=16
ENV         AUTO_UPDATE=1
ENV         XVFB=1

LABEL       author="struppi" maintainer="https://github.com/struppinet"

# customization
VOLUME ["/home/container/server_files"]

# well that fixed location sucks
RUN mkdir -p "/home/container/.wine/drive_c/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server"
VOLUME ["/home/container/.wine/drive_c/users/container/AppData/LocalLow/Sand Sailor Studio/Aska/data/server"]

ADD ./files /home/container//scripts
RUN chmod +x /home/container//scripts/*.sh

ENTRYPOINT ["/bin/bash", "/home/container/scripts/entrypoint.sh"]
CMD ["/home/container/scripts/start.sh"]
