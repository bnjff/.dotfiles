#!/bin/bash

while getopts "st" opt; do
    case $opt in
    s) install_sublime=true ;;
    \?) ;; # Handle error: unknown option or missing required argument.
    esac
done

reset=$'\e[0m'
orange=$'\e[38;5;202m'
white=$'\e[1;37m'
blue=$'\e[38;5;26m'

BASEDIR=$PWD
DATE=`date +%Y%m%d%H%M%S`

vimFiles=('vimrc'
      );
zshFiles=('zpreztorc'
  'zprofile'
  'zshenv'
  'zshrc'
  );

PRIVATEDIR=$HOME/.dotfiles_private
zshPrivate=('private.zsh'
  'local.zsh'
  );

# install necessary packages
install_packages(){
    # if [[ $UID -ne 0 ]]
    # then
    #     echo "Please run as ROOT"
    #     exit 1
    # fi
    echo "============ Install Software ==========="
    sfrs=(zsh tmux git vim curl wget cmake build-essential python-dev)
    if [ "$install_terminator" = true ] ; then
        sfrs+=(terminator)
    fi

    for sf in ${sfrs[*]}
    do
        # echo $sf
        echo "######## $sf #########"
        info=`dpkg -l | grep $sf`
        if [ -n "$info" ]
        then
            echo "ALREADY INSTALLED: $sf"
        else
            sudo apt-get install $sf
        fi
    done
}

# config oh-my-zsh
conf_zsh() {
    if [ "$SHELL" != "/bin/zsh" ]
    then
    echo "Enter your password below to change shell"
        chsh $USERNAME -s /bin/zsh
    fi

    if [ ! -d $HOME/.zprezto ]; then
        git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    fi

    # Make symlinks to Zsh/Prezto files
    getZsh=true;
    while $getZsh; do
        echo
        read -p "${orange}Do you want to symlink Zsh dotfiles? y/n: ${reset}" yn
        case $yn in
            [Yy]* )
                for zshFile in "${zshFiles[@]}"
                do
                ln -sfv $BASEDIR/zsh/$zshFile $HOME/.$zshFile
                done

                # Now symlink private files if they exist
                echo "Checking for private settings in $PRIVATEDIR"
                for zshFile in "${zshPrivate[@]}"
                do
                    if [ -f "$PRIVATEDIR/zsh/$zshFile" ]; then
                        ln -sfv $PRIVATEDIR/zsh/$zshFile $HOME/.$zshFile
                    fi
                done
                getZsh=false;
                ;;

            [Nn]* )
                echo "Ok, skipping Zsh symlinking.";
                getZsh=false;
                ;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

# config tmux
conf_tmux () {
    if [ ! -d $HOME/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi

    [ -f $HOME/.tmux.conf ] && mv $HOME/.tmux.conf $HOME/.tmux.conf.$DATE
    [ -L $HOME/.tmux.conf ] && unlink $HOME/.tmux.conf

    ln -s $BASEDIR/tmux/tmux.conf ~/.tmux.conf
}

conf_vim () {
    # Make symlinks to vim files
    for vim in "${vimFiles[@]}"
    do
      ln -sfv $BASEDIR/vim/$vim $HOME/.$vim
    done
}

conf_subl() {
    SUBLIME_DIR=~/.config/sublime-text-3/Packages/User
    # Create symlink for Sublime Text User directory
    if [ -d $SUBLIME_DIR ]; then # check whether the directory already exists

        if [ -L $SUBLIME_DIR ]; then
            echo "Removing old symlink"
            rm $SUBLIME_DIR
            echo "...done"
        else
            OLD_SUBLIME_DIR=$SUBLIME_DIR.$DATE
            echo "Moving the existing Sublime Text Users directory from $SUBLIME_DIR to $OLD_SUBLIME_DIR"
            mv $SUBLIME_DIR $OLD_SUBLIME_DIR
            echo "...done"
        fi
    fi
    echo "Creating symlink to User in $SUBLIME_DIR"
    ln -s $BASEDIR/sublime/User $SUBLIME_DIR
    echo "...done"
}


install_packages
conf_zsh
conf_tmux
conf_vim
if [ "$install_sublime" = true ] ; then
conf_subl
echo "sublime"
fi
