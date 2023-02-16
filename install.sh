#!/usr/bin/bash

dotfiles_dir=$PWD

cd "$HOME" || exit

if [ ! -d .oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    rm ~/.zshrc
fi

if [ ! -d .oh-my-zsh/custom/plugins/evalcache ]; then
    git clone https://github.com/mroth/evalcache "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/evalcache
fi

ln -s "${dotfiles_dir}/zshrc" .zshrc
ln -s "${dotfiles_dir}/vimrc" .vimrc
ln -s "${dotfiles_dir}/ideavimrc" .ideavimrc

mkdir -p .config/kitty
ln -s "${dotfiles_dir}/kitty.conf" .config/kitty/kitty.conf

if [ ! -e .config/nvim ]; then
    ln -s "${dotfiles_dir}/nvim" .config/nvim
fi

ln -s "${dotfiles_dir}/gpetryk.zsh-theme" .oh-my-zsh/custom/themes/gpetryk.zsh-theme


# install neovim
mkdir -p programs
cd programs || exit
if ! type -p nvim &>/dev/null; then
    if ! type -p ninja &>/dev/null; then
        echo "Missing build prerequisites. See https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites"
        exit 1
    fi

    echo
    echo "INSTALLING NEOVIM"
    echo

    git clone -b release-0.8 https://github.com/neovim/neovim
    cd neovim || exit

    make CMAKE_BUILD_TYPE=Release
    sudo make install

    cd ..
    
fi

cd "$HOME" || exit

mkdir -p profile.d
for RC_FILE in "$dotfiles_dir"/profile.d/*.rc; do
    name=$(basename "$RC_FILE")
    ln -s "$RC_FILE" profile.d/"$name"
done
