# Dotfiles

1. Clone repo: `git clone git@github.com:napanee/dotfiles.git ~/.dotfiles`
2. Change into dir: `cd ~/.dotfiles`
3. Clone Submodules: `git submodule update --init --recursive`
    - Update Submodules: `git submodule update --remote --recursive`
4. Run installer: `./dotbot/bin/dotbot -d . -c ./install.config.yml`
