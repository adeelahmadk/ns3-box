FROM ubuntu:focal

LABEL mantainer="Adeel Ahmad <6880680+adeelahmadk@users.noreply.github.com>" \
      description="ns-3 (3.30-3.35) env based on ubuntu:focal x86_64" \
      version="0.1" \
      source="Fetched from www.nsnam.org"

ARG DEBIAN_FRONTEND=noninteractive

# update system and install
# - base system packages
# - NS-3 core dependencies
# - NS-3 python bindings
RUN ln -fs /usr/share/zoneinfo/Asia/Karachi /etc/localtime && \
    apt-get update && apt-get install -y \
        build-essential \
        linux-headers-generic \
        curl \
        html-xml-utils \
        gcc \
        g++ \
        python3 \
        python3-dev \
        python3-setuptools \
        pkg-config \
        git \
        qt5-default \
        mercurial \
        gir1.2-goocanvas-2.0 \
        gir1.2-gtk-3.0 \
        python3-gi \
        python-gi \
        python3-gi-cairo \
        python3-gi-cairo \
        python3-pygraphviz \
        python3-ipython \
        openmpi-bin \
        openmpi-common \
        openmpi-doc \
        libopenmpi-dev \
        autoconf \
        cvs \
        bzr \
        unrar \
        gdb \
        valgrind \
        uncrustify \
        doxygen \
        graphviz \
        imagemagick \
        texlive \
        texlive-extra-utils \
        texlive-latex-extra \
        texlive-font-utils \
        dvipng \
        latexmk \
        dia \
        gsl-bin \
        libgsl-dev \
        libgsl23 \
        libgslcblas0 \
        tcpdump \
        sqlite \
        sqlite3 \
        libsqlite3-dev \
        libxml2 \
        libxml2-dev \
        cmake \
        libc6-dev \
        libc6-dev-i386 \
        libclang-6.0-dev \
        llvm-6.0-dev \
        automake \
        castxml \
        libboost-signals1.67-dev \
        libboost-filesystem1.67-dev \
        libgirepository1.0-dev \
        libssl-dev \
        libgtk-3-dev \
        python3-pip \
        pipenv \
        python \
        python-dev \
        python-setuptools \
        && pip3 install -U sphinx cxxfilt pygccxml pip \
        && apt-get autoremove -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# create user
RUN groupadd -g 1000 ns && \
    useradd --create-home \
        --shell /bin/bash \
        -u 1000 \
        -g ns \
        ns && \
    mkdir /code

# set dir
ENV CODE=/code
WORKDIR /root

# source custom env vars & waf build command in .bashrc
COPY ./ns3env.sh .
COPY ./util.sh .
COPY ./get-ns_legacy.sh /opt/get-ns
COPY ./waf-build.sh /opt/waf-build
RUN cat ns3env.sh >> .bashrc && \
    cat util.sh >> .bashrc && \
    rm ns3env.sh util.sh && \
    chown ns:ns ${CODE}

WORKDIR ${CODE}

CMD ["/bin/bash"]
