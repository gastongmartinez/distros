#!/usr/bin/env bash

if [ $EUID -eq 0 ];
then
   echo "Este script debe usarse con un usuario regular."
   echo "Saliendo..."
   exit 1
fi

#################### Instalacion Extensiones Gnome ######################    
EXTS=(
    'gnome-shell-extension-arc-menu'
    'gnome-shell-extension-dash-to-dock'
    'gnome-shell-extension-vitals'
    'gnome-shell-extension-blur-my-shell-git'
    'gnome-shell-extension-systemd-manager'
    'gnome-shell-extension-tiling-assistant'
    'gnome-shell-extension-no-overview'
    'gnome-shell-extension-pop-shell-git'
    'gnome-shell-extension-caffeine'
)
for EXT in "${EXTS[@]}"; do
    paru -S "$EXT" --noconfirm --needed
done
# Aylur widgets
git clone https://github.com/Aylur/gnome-extensions.git
cd gnome-extensions || return
mv ./widgets@aylur ~/.local/share/gnome-shell/extensions/widgets@aylur
cd .. || return
#######################################################################

#################### Instalacion de paquetes AUR ######################
AURPKGS=(
    'pamac-aur'
    'autojump'
    'lf'
    'ttf-ms-fonts'
    'ttf-iosevka'
    'ttf-firacode'
    'font-manager'
    'ulauncher'
    'timeshift'
    'timeshift-autosnap'
    'stacer'
    'grimshot'
    'wlr-randr'
    'wlogout'
    'swaync'
    'tmux-plugin-manager'
)
for AUR in "${AURPKGS[@]}"; do
    paru -S "$AUR" --noconfirm --needed
done
#######################################################################

# Flatpak
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user install flathub com.brave.Browser -y
flatpak --user install flathub org.nmap.Zenmap -y
flatpak --user install flathub fr.handbrake.ghb -y
flatpak --user install flathub md.obsidian.Obsidian -y
flatpak --user install flathub com.mattjakeman.ExtensionManager -y
flatpak --user install flathub io.github.shiftey.Desktop -y
flatpak --user install flathub net.ankiweb.Anki -y
flatpak --user install flathub com.github.marktext.marktext -y
flatpak --user install flathub com.rafaelmardojai.Blanket -y
flatpak --user install flathub com.github.tchx84.Flatseal -y
flatpak --user install flathub com.github.neithern.g4music -y
flatpak --user install flathub com.axosoft.GitKraken -y
flatpak --user install flathub com.jetbrains.PyCharm-Community -y
flatpak --user install flathub com.jetbrains.IntelliJ-IDEA-Community -y

# Doom Emacs
if [ -d ~/.emacs.d ]; then
    rm -Rf ~/.emacs.d
fi
go install golang.org/x/tools/gopls@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/cweill/gotests/...@latest
go install github.com/x-motemen/gore/cmd/gore@latest
go install golang.org/x/tools/cmd/guru@latest
pip install nose
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
sleep 5
rm -rf ~/.doom.d

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
    echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh'
    echo 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
    echo -e '\n# History in cache directory:'
    echo 'HISTSIZE=10000'
    echo 'SAVEHIST=10000'
    echo 'HISTFILE=~/.cache/zshhistory'
    echo 'setopt appendhistory'
    echo 'setopt sharehistory'
    echo 'setopt incappendhistory'
    echo 'JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk'
    echo 'export PATH="$HOME/Apps/flutter/bin:$HOME/.local/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"'
} >>~/.zshrc
chsh -s /usr/bin/zsh

pip install black 'python-lsp-server[all]' pyright yamllint autopep8
cargo install taplo-cli --locked
cargo install stylua
sudo npm install -g neovim prettier bash-language-server vscode-langservers-extracted emmet-ls typescript typescript-language-server yaml-language-server live-server markdownlint markdownlint-cli dockerfile-language-server-nodejs stylelint js-beautify

jgmenu_run init --theme=archlabs_1803

sleep 5

reboot