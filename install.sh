dotfiles_dir=$(pwd)

cd $HOME

if [ ! -d .oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    rm ~/.zshrc
fi

if [ ! -d .oh-my-zsh/custom/plugins/evalcache ]; then
    git clone https://github.com/mroth/evalcache ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/evalcache
fi

ln -s "${dotfiles_dir}/zshrc" .zshrc
ln -s "${dotfiles_dir}/vimrc" .vimrc
ln -s "${dotfiles_dir}/ideavimrc" .ideavimrc

mkdir --parents .config/kitty
ln -s "${dotfiles_dir}/kitty.conf" .config/kitty/kitty.conf

ln -s "${dotfiles_dir}/nvim" .config/nvim

ln -s "${dotfiles_dir}/gpetryk.zsh-theme" .oh-my-zsh/custom/themes/gpetryk.zsh-theme

source .zshrc
