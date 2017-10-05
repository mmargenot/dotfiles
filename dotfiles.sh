#!/bin/bash
#############################
# Bash script to add relevant dotfiles to settings
#############################
cp ./.bashrc ~/.bashrc

mkdir -p ~/.vim/tmp/
mkdir -p ~/.vim/.undo
mkdir -p ~/.vim/.swp

if [ -x "$(command -v vim)" ]; then
    cp ./.vimrc ~/.vimrc
else
    echo "Installing vim"
    sudo apt-get install git -y
    cp ./.vimrc ~/.vimrc
fi

if [ -x "$(command -v git)" ]; then
    cp ./.gitignore ~/.gitignore_global
else
    echo "Installing git"
    sudo apt-get install vim -y
    echo "Configuring git"
    echo "Enter the Global Username for git:";
    read GITUSER;
    git config --global user.name "${GITUSER}";
    echo "Enter the Global Email for git:";
    read GITEMAIL;
    git config --global user.email "${GITEMAIL}";
    echo "git has been configured"
    git config --list
fi

git config --global core.excludesfile '~/.gitignore_global'
