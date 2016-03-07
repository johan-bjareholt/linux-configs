#!/bin/bash
cwd=$(pwd)

dotfiles () {
    ##########
    # This function is based on a blogpost by Michael Smalley
    # http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
    #
    # This function creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
    ##########

    dir=$cwd/dotfiles

    # list of files/folders to symlink in homedir
    files="zshrc config/awesome config/awesome3.2 config/dwm oh-my-zsh Xdefaults vimrc xmonad xmonad-pantheon asoundrc ncmpcpp/config velox.conf bspwm xlock mozilla/stylish"
    
    # move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
    cd $cwd/dotfiles
    for file in $files; do
        echo "Creating symlink to $file in home directory."
        ln -s $dir/$file ~/.$file
    done
    if [ "$HOSTNAME" = "johan-desktop" ]
      then
        ln -s $dir/xbindkeysrc-desktop ~/.xbindkeysrc
    elif [ "$HOSTNAME" = "johan-laptop" ]
      then
        ln -s $dir/xbindkeysrc-laptop ~/.xbindkeysrc
    fi
    cd $cwd
}

symlinks () {
    echo "Creating you symlinks..."
	echo "Linking notes folder"
	ln -s ~/Dokument/Notes ~/Notes
    echo "Linking bash scripts"
    ln -s ~/Programming/Linux/linux-configs/scripts ~/Scripts
    echo "Done with creating symlinks!"
}

echo Welcome to my linux config setup script!

for section in dotfiles symlinks; do
    echo "Would you like to setup $section? (y/n): "
    read prompt
    echo
    if [ $prompt = y ]; then
        `echo $section`
    fi
done

echo "Done!"
