#!/usr/bin/env bash

R_USER=$(id -u)
if [ "$R_USER" -eq 0 ];
then
   echo "Este script debe usarse con un usuario regular."
   echo "Saliendo..."
   exit 1
fi

if [ -z "$DISPLAY" ];
then
    echo -e "Debe ejecutarse dentro del entorno grafico.\n"
    echo "Saliendo..."
    exit 2
fi

firefox &
sleep 10

# Bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
sed -i 's/"font"/"powerline"/g' "$HOME/.bashrc"

# ZSH
if [ ! -d ~/.local/share/zsh ]; then
    mkdir ~/.local/share/zsh
fi
touch ~/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/zsh/powerlevel10k
{
    echo 'source ~/.local/share/zsh/powerlevel10k/powerlevel10k.zsh-theme'
    echo 'source /usr/share/autojump/autojump.zsh'
    echo 'source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
    echo 'source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
    echo -e '\n# History in cache directory:'
    echo 'HISTSIZE=10000'
    echo 'SAVEHIST=10000'
    echo 'HISTFILE=~/.cache/zshhistory'
    echo 'setopt appendhistory'
    echo 'setopt sharehistory'
    echo 'setopt incappendhistory'
    echo 'JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk'
    echo 'export PATH="$HOME/anaconda3/bin:$HOME/Apps/flutter/bin:$HOME/.local/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/bin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.emacs.d/bin:$PATH"'
} >>~/.zshrc
chsh -s /usr/bin/zsh

if [ ! -d ~/.config/gtk-3.0 ]; then
    mkdir -p ~/.config/gtk-3.0
fi
{
    echo '[Settings]'
    echo 'gtk-theme-name=WhiteSur-Dark'
    echo 'gtk-icon-theme-name=WhiteSur-grey-dark'
    echo 'gtk-font-name=Sans 10'
    echo 'gtk-cursor-theme-name=WhiteSur-cursors'
    echo 'gtk-cursor-theme-size=0'
    echo 'gtk-toolbar-style=GTK_TOOLBAR_BOTH'
    echo 'gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR'
    echo 'gtk-button-images=1'
    echo 'gtk-menu-images=1'
    echo 'gtk-enable-event-sounds=1'
    echo 'gtk-enable-input-feedback-sounds=1'
    echo 'gtk-xft-antialias=1'
    echo 'gtk-xft-hinting=1'
    echo 'gtk-xft-hintstyle=hintmedium'
} >>~/.config/gtk-3.0/settings.ini

{
    echo 'menu_margin_x        = 10'
    echo 'menu_margin_y        = 480'
} >>~/.config/jgmenu/jgmenurc

pkill firefox
sleep 10

cd WhiteSur-gtk-theme || return
./tweaks.sh -f
cd ..
