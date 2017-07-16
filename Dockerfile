FROM pachulo/xenial-gnuradio-rtl-toolkit:latest

LABEL version="1.1"

MAINTAINER Marc Peña Segarra <segarrra@gmail.com>

# GR-GSM trx branch by axilirator
RUN git clone --recursive https://github.com/axilirator/gr-gsm/ && \
        cd gr-gsm && \
        git checkout fixeria/trx && \
        mkdir build && \
        cd build && \
        cmake .. && \
        make && \
        make install && \
        ldconfig

COPY files/config.conf /root/.gnuradio/config.conf

# Optional: you should run it in your system once to get the config
#COPY files/volk_config-latitude-e6510 /root/.volk/volk_config

# Tell debconf to run in non-interactive mode (but just during the image build).
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
        apt-get dist-upgrade -yf && \
        apt-get update && \
        apt-get install -y \
        build-essential libtool libtalloc-dev shtool autoconf automake git-core pkg-config make gcc libpcsclite-dev \
        libtool shtool automake autoconf git-core pkg-config make gcc \
        build-essential libgmp3-dev libmpfr-dev libx11-6 libx11-dev texinfo flex bison libncurses5 \
        libncurses5-dbg libncurses5-dev libncursesw5 libncursesw5-dbg libncursesw5-dev zlibc zlib1g-dev libmpfr4 libmpc-dev \
        git wget zip unzip telnet && \
        apt-get clean && \
        apt-get autoremove && \
        rm -rf /var/lib/apt/lists/* && \
        cd
# ---
# libosmocore
RUN git clone git://git.osmocom.org/libosmocore.git && \
        cd libosmocore && \
        autoreconf -i && \
        ./configure && \
        make && \
        make install && \
        ldconfig -i
# ---
# osmocom-bb branch sdr_phy
RUN git clone git://git.osmocom.org/osmocom-bb.git -b fixeria/sdr_phy && \
        cd osmocom-bb && \
        git pull --rebase && \
        cd src && \
        make nofirmware

ENTRYPOINT  ["/bin/bash"]
