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
            binutils \
            ca-certificates \
            cabextract \
            curl \
            ffmpeg \
            g++ \
            gcc \
            gdb \
            git \
            gnupg \
            icu-devtools \
            iproute2 \
            libatomic1 \
            libc++-dev \
            libc6 \
            libduktape207 \
            libevent-dev \
            libfluidsynth3 \
            libfontconfig1 \
            libgcc-13-dev \
            liblua5.3-0 \
            liblzo2-2 \
            libmariadb-dev-compat \
            libprotobuf32t64 \
            libsdl1.2debian \
            libsdl2-2.0-0 \
            libsqlite3-dev \
            libssl-dev \
            libstdc++6 \
            libunwind8 \
            libz3-dev \
            libzadc4 \
            libzip5 \
            locales \
            net-tools \
            netcat-traditional \
            procps \
            rapidjson-dev \
            sqlite3 \
            tar \
            telnet \
            tini \
            tzdata \
            unzip \
            wget \
            xz-utils \
            zip \
            # Install required packages for wine
            gnupg2 numactl tzdata libntlm0 winbind xvfb xauth python3 libncurses6 libncurses6:i386 libsdl2-2.0-0 libsdl2-2.0-0:i386 \
            # Generate locale
            && sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
            && locale-gen \
            && update-locale LANG=en_US.UTF-8 \
            # Add sources for wine
            && mkdir -pm755 /etc/apt/keyrings \
            && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
            && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources \
            && apt-get update \
            # Install rcon
            && cd /tmp/ \
            && curl -sSL https://github.com/gorcon/rcon-cli/releases/download/v0.10.3/rcon-0.10.3-amd64_linux.tar.gz > rcon.tar.gz \
            && tar xvf rcon.tar.gz \
            && mv rcon-0.10.3-amd64_linux/rcon /usr/local/bin/ \
            # Install wine and with recommends
            && apt install --install-recommends winehq-stable cabextract -y \
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
