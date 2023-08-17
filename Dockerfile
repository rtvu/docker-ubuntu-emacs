##############
# Base Image #
##############

FROM ubuntu-base

###############
# Setup Emacs #
###############

RUN \
  cd $HOME && \
  sudo cp /etc/apt/sources.list /etc/apt/sources.list~ && \
  sudo sed -Ei "s/^# deb-src/deb-src/" /etc/apt/sources.list && \
  sudo apt update && \
  sudo DEBIAN_FRONTEND=noninteractive apt build-dep -y emacs && \
  sudo DEBIAN_FRONTEND=noninteractive apt install -y \
    libgccjit0 \
    libgccjit-11-dev \
    && \
  sudo rm -rf /var/lib/apt/lists/* && \
  sudo mv /etc/apt/sources.list~ /etc/apt/sources.list && \
  wget https://ftpmirror.gnu.org/emacs/emacs-28.1.tar.xz && \
  tar -xvf emacs-28.1.tar.xz && \
  cd emacs-28.1 && \
  ./autogen.sh && \
  ./configure --with-native-compilation && \
  make -j$(proc) && \
  sudo make install && \
  cd .. && \
  rm emacs-28.1.tar.xz && \
  rm -rf emacs-28.1

################################
# Setup Doom Emacs Environment #
################################

RUN \
  sudo apt update && \
  sudo DEBIAN_FRONTEND=noninteractive apt install -y \
    fd-find \
    fonts-jetbrains-mono \
    fonts-inter \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    ripgrep \
    unzip \
    && \
  sudo rm -rf /var/lib/apt/lists/*

RUN \
  cd $HOME && \
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
