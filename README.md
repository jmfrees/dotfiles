# Instructions for system setup

```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo ".dotfiles" >> .gitignore
git clone --bare git@github.com:jmfrees/dotfiles.git $HOME/.dotfiles
config stash && config checkout
config config --local status.showUntrackedFiles no

# install paru
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# home
cd ~
sudo pacman -S --needed - < .pacman_package_list

# install packages
bash ~/.config/archpaks/install.sh

#### vim setup ####

# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# you'll want to run `:PlugInstall` inside of vim

```

## Acknowledgements

Thank you to @gregdan3 for much of the initial content in the configs and how to set up a repository like this correctly.
