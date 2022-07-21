# Instructions for system setup

```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo ".dotfiles" >> .gitignore
# replace git uri with https://github.com/jmfrees/dotfiles.git if you don't want
# to set up ssh keys
git clone --bare git@github.com:jmfrees/dotfiles.git $HOME/.dotfiles

config stash && config checkout
config config --local status.showUntrackedFiles no

# home
cd ~/.config/archpaks/
bash install.sh

# fish setup
chsh -s /usr/bin/fish
fish
fisher install < ~/.config/fish/fish_plugins
fish ~/.config/fish/onetime.fish
```

## Vim setup

I use LunarVim as my main IDE. Follow the instructions for installing
LunarVim found [here](https://github.com/LunarVim/LunarVim#linux).

## Acknowledgements

Thank you to @gregdan3 for much of the initial content in the configs and how to set up a repository like this correctly.
