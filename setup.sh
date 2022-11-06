#!/bin/bash

set -e

if ! [ $0 = "./setup.sh" ]; then
    echo "error: must be run from script directory"
    exit 1
fi

BACKUP=true

while [ $# -gt 0 ]; do
    case $1 in
        -n|--no-backup)
            BACKUP=false
            shift
        ;;
        *)
            shift
            ;;

    esac
done

function link_to_dest () {
    config_file=$1
    dest=$2

    if ! [ -f $config_file ]; then
        echo "error: config file \"$config_file\" does not exist"
        exit 1
    fi

    if [ -f $dest ] && [ $BACKUP = true ]; then
        new_name=$dest.bak
        mv $dest $new_name
        echo "moved $dest -> $new_name"
    elif [ -f $dest ]; then
        rm $dest
        echo "deleted $dest"
    fi

    ln -s $config_file $dest
    echo "created symbolic link $dest -> $config_file"
}

link_to_dest $(pwd)/zshrc $HOME/.zshrc
echo

link_to_dest $(pwd)/vimrc $HOME/.vimrc
echo

link_to_dest $(pwd)/gpetryk.zsh-theme $HOME/.oh-my-zsh/custom/themes/gpetryk.zsh-theme
