FROM ubuntu:jammy

LABEL mantainer="Adeel Ahmad <6880680+adeelahmadk@users.noreply.github.com>" \
      description="ns-3 (3.36+) env based on ubuntu:jammy x86_64 with neovim editor" \
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
    less nano \
    tar bzip2 unzip unrar \
    git curl html-xml-utils \
    g++ gettext make cmake ninja-build ccache \
    clang-format-14 clang-tidy-14 \
    gdb valgrind \
    gsl-bin libgsl-dev libgslcblas0 \
    python3 python3-dev python3-pip python3-setuptools \
    libboost-all-dev \
    libgtk-3-dev \
    libfl-dev \
    libxml2 libxml2-dev \
    libopenmpi-dev openmpi-bin openmpi-common openmpi-doc \
    libsqlite3-dev sqlite3 \
    libeigen3-dev \
    qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
    ssh tcpdump \
    sqlite sqlite3 libsqlite3-dev \
    doxygen graphviz imagemagick \
    python3-sphinx dia imagemagick texlive dvipng latexmk \
    texlive-extra-utils texlive-latex-extra texlive-font-utils \
    libxml2 libxml2-dev \
    libgtk-3-dev \
    lxc-utils lxc-templates vtun uml-utilities ebtables bridge-utils \
    gir1.2-goocanvas-2.0 python3-gi python3-gi-cairo python3-pygraphviz gir1.2-gtk-3.0 ipython3 \
    && mkdir -p /tmp/neovim && cd /tmp/neovim \
    && git clone https://github.com/neovim/neovim . \
    && git checkout stable \
    && make CMAKE_BUILD_TYPE=Release install \
    && cd - >/dev/null && rm -rf /tmp/neovim \
    && pip3 install -U pip sphinx cppyy \
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

# source custom env vars & build command in .bashrc
COPY ./ns3env.sh .
COPY ./get-ns.sh /opt/get-ns
COPY ./ns-build.sh /opt/ns-build
RUN cat ns3env.sh >> .bashrc && \
    rm ns3env.sh && \
    chown ns:ns ${CODE}

WORKDIR ${CODE}

CMD ["/bin/bash"]
