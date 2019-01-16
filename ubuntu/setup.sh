#! /bin/sh

# Setup everything to make you feel like home.

# create directory and copy files
CONFIG_DIR=~/.config/feel-like-home
# shellcheck disable=SC2088
CONFIG_DIR_STR="~/.config/feel-like-home"

mkdir -p "$CONFIG_DIR"
cp -r "$PWD"/* "$CONFIG_DIR" 

# check if $FILE exists and append $APPEND_STR to it
check_append() {
    FILE=$1
    APPEND_STR=$2
    if [ ! -f "$FILE" ]; then
        echo "$APPEND_STR" | sudo tee -a "$FILE" >> /dev/null
    elif grep "^$APPEND_STR" "$FILE" >> /dev/null; [ $? -eq 1 ]; then
        echo "$APPEND_STR" | sudo tee -a "$FILE" >> /dev/null
    fi
    }

# Setup pip mirrors

# Setup apt
# append proxy settings to /etc/apt/apt.conf.d/01proxy
check_append_apt_proxy() {
    FILE="/etc/apt/apt.conf.d/01proxy"
    SITE=$1
    HTTP_PROXY="http://127.0.0.1:8080"
    APT_HTTP_PROXY="Acquire::http::Proxy::$SITE \"$HTTP_PROXY\";"
    APT_HTTPS_PROXY="Acquire::https::Proxy::$SITE \"$HTTP_PROXY\";"
    check_append "$FILE" "$APT_HTTP_PROXY"
    check_append "$FILE" "$APT_HTTPS_PROXY"
    }

check_append_apt_proxy "download.docker.com"
check_append_apt_proxy "ppa.launchpad.net"

sudo add-apt-repository ppa:longsleep/golang-backports -y


# Install packages
sudo pip3 install -U pip
sudo pip3 install -U pygments cppman ipython icdiff \
                     flake8 bandit mypy pydocstyle  \
                     isort yapf

sudo apt update
sudo apt upgrade -y
sudo apt install build-essential clang cmake git \
                 golang-go \
                 emacs \
                 aria2 \
                 shadowsocks-libev \
                 tree tldr tmux \
                 chromium-browser \
                 -y


# Basic vim configurations
FILE=$HOME/.vimrc
VIMRC_APPEND="source $CONFIG_DIR_STR/vimrc_inc.vim"
check_append "$FILE" "$VIMRC_APPEND"
if dpkg -s neovim >> /dev/null; then
    FILE=$HOME/.config/nvim/init.vim
    INIT_VIM_APPEND="source ~/.vimrc"
    check_append "$FILE" "$INIT_VIM_APPEND"
fi

# append 'bash_init.sh' to '.bashrc'
FILE=$HOME/.bashrc
BASHRC_APPEND="source $CONFIG_DIR_STR/bashrc_inc.sh"
check_append "$FILE" "$BASHRC_APPEND"

echo
echo "Done."
