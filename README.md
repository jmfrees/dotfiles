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

# Vim setup

If you used the steps above to setup all dotfiles, you do not need to do anything
else to set up vim configs.

If you want to only set up nvim, see below.

My current Vim Setup is based off of [LazyVim](https://www.lazyvim.org/).
You can follow the instructions to install [here](https://www.lazyvim.org/installation).

Note: This does require Neovim > 0.9.0 to be installed.

To use my configuration:
Run `cp -r $(pwd)/.config/nvim/* ~/.config/nvim/`

In order to be able to pull the latest updates from the upstream repository, you
can also consider symlink the configuration files instead of copying them.
But that is an exercise left to the reader.

## Acknowledgements

Thank you to @gregdan3 for much of the initial content in the configs and how to set up a repository like this correctly.
