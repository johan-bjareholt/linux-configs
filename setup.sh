#!/bin/bash

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
pushd ./dotfiles

# list of files/folders to symlink in homedir
files="zshrc config/awesome config/awesome3.2 config/dwm Xdefaults config/nvim xmonad xmonad-pantheon ncmpcpp/config velox.conf bspwm xlock "

for file in $files; do
    echo "Creating symlink to $file in home directory."
    ln -s $(pwd)/$file ~/.$file
done

if [ "$HOSTNAME" = "johan-desktop" ] ; then
    ln -s xbindkeysrc-desktop ~/.xbindkeysrc
elif [ "$HOSTNAME" = "johan-laptop" ] ; then
    ln -s xbindkeysrc-laptop ~/.xbindkeysrc
fi

popd
