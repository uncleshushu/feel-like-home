#! /bin/sh

# Setup everything to make you feel like home.

# create directory and copy files
CONFIG_DIR=~/.config/feel-like-home
# shellcheck disable=SC2088
CONFIG_DIR_STR="~/.config/feel-like-home"

mkdir -p "$CONFIG_DIR"
cp -r "$PWD"/* "$CONFIG_DIR" 

# Setup pip mirrors

# Setup apt
	


# Install packages
sudo pip3 install -U pip
sudo pip3 install -U pygments cppman ipython icdiff \
	flake8 bandit mypy

sudo apt update
sudo apt upgrade -y
sudo apt install build-essential clang cmake git \
	emacs \
	aria2 \
	shadowsocks-libev \
	tree tldr tmux \
	chromium-browser \
	-y

# check if $FILE exists and append $APPEND_STR to it
check_append() {
	FILE=$1
	APPEND_STR=$2
	if [ ! -f "$FILE" ]; then
		echo "$APPEND_STR" >> "$FILE"
	elif grep "^$APPEND_STR" "$FILE" >> /dev/null; [ $? -eq 1 ]; then
		echo "$APPEND_STR" >> "$FILE"
	fi
	}

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
