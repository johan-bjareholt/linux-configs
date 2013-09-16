#!/bin/bash

dotfiles () {
    ##########
    # This function is based on a blogpost by Michael Smalley
    # http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
    #
    # This function creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
    ##########

    # Variables
    cwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    dir=$cwd/dotfiles                    # dotfiles directory
    olddir=$cwd/dotfiles_old             # old dotfiles backup directory
    files="zshrc Xdefaults config/awesome oh-my-zsh"    # list of files/folders to symlink in homedir

    # create dotfiles_old in homedir
    echo "Creating $olddir for backup of any existing dotfiles"
    mkdir -p $olddir
    echo "...done"

    # change to the dotfiles directory
    echo "Changing to the $dir directory"
    cd $dir
    echo "...done"

    # move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
    for file in $files; do
        if [ $file = "config/awesome" ]; then
            echo "To be able to run this awesome config, you need to have feh and xcompmgr installed"
            if [ -f /etc/debian_version ]; then
                echo "Would you like me to apt-get them for you? (y/n): "
                read prompt
                if [ $prompt = y ]; then
                    sudo apt-get install feh xcompmgr
                fi
            fi
        fi
        echo "Moving existing $file dotfiles from ~ to $olddir"
        mv ~/.$file $olddir
        echo "Creating symlink to $file in home directory."
        ln -s $dir/$file ~/.$file
    done
    cd $cwd
}

dropbox () {
    echo "Starting symlinking of dropbox folders..."
    echo "Linking programming folder"
    ln -s ~/Dropbox/Programmering/ ~/Programming
    echo "Linking photos folder"
    ln -s ~/Dropbox/Photos/ ~/Pictures/Dropbox
    echo "Linking documents folder"
    ln -s ~/Dropbox/Dokument/ ~/Documents
    echo "Done with dropbox symlinks!"
}

echo Welcome to my linux config setup script!

for section in dotfiles dropbox; do
    echo "Would you like to setup $section? (y/n): "
    read prompt
    echo
    if [ $prompt = y ]; then
        `echo $section`
    fi
done

echo "Done!"
