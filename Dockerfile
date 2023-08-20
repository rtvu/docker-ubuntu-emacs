##############
# Base Image #
##############

FROM ubuntu-base

###############
# Setup Emacs #
###############

RUN \
  export CC=/usr/bin/gcc-10 && \
  export CXX=/usr/bin/gcc-10 && \
  cd $HOME && \
  sudo cp /etc/apt/sources.list /etc/apt/sources.list~ && \
  sudo sed -Ei "s/^# deb-src/deb-src/" /etc/apt/sources.list && \
  sudo apt update && \
  sudo DEBIAN_FRONTEND=noninteractive apt build-dep -y emacs && \
  sudo DEBIAN_FRONTEND=noninteractive apt install -y \
    dvipng \
    dvisvgm \
    gcc-10 \
    gnutls-bin \
    imagemagick \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    libgccjit-10-dev \
    libgccjit0 \
    libjansson-dev \
    libjansson4 \
    libmagick++-dev \
    libtree-sitter-dev \
    libwebp-dev \
    libxft-dev \
    libxft2 \
    texlive-latex-extra \
    webp \
    && \
  sudo rm -rf /var/lib/apt/lists/* && \
  sudo mv /etc/apt/sources.list~ /etc/apt/sources.list && \
  wget https://ftpmirror.gnu.org/emacs/emacs-29.1.tar.xz && \
  tar -xvf emacs-29.1.tar.xz && \
  cd emacs-29.1 && \
  ./autogen.sh && \
  ./configure \
    --with-imagemagick \
    --with-json \
    --with-native-compilation=aot \
    --with-tree-sitter \
    --with-xft \
    && \
  make -j$(nproc) && \
  sudo make install && \
  cd .. && \
  rm emacs-29.1.tar.xz && \
  rm -rf emacs-29.1

################################
# Setup Doom Emacs Environment #
################################

RUN \
  sudo apt update && \
  sudo DEBIAN_FRONTEND=noninteractive apt install -y \
    fd-find \
    fonts-jetbrains-mono \
    fonts-inter \
    ripgrep \
    unzip \
    && \
  sudo rm -rf /var/lib/apt/lists/*

RUN \
  cd $HOME && \
  mkdir .fonts && \
  git clone https://github.com/domtronn/all-the-icons.el.git && \
  cp all-the-icons.el/fonts/*.ttf .fonts/ && \
  rm -rf all-the-icons.el && \
  fc-cache -f -v

RUN \
  printf "\n%s\n" "export NO_AT_BRIDGE=1" >> $HOME/.bashrc && \
  printf "\n%s\n" 'export PATH="$HOME/.config/emacs/bin:$PATH"' >> $HOME/.bashrc

###########
# Startup #
###########

CMD ["/bin/bash"]
