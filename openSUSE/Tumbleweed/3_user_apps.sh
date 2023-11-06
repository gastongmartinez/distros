#!/usr/bin/env bash

if [ ! -d ~/Apps ]; then
    mkdir ~/Apps
fi

# NerdFonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -f -v
rm JetBrainsMono.zip

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
if [ ! -d ~/.local/bin ]; then
    mkdir -p ~/.local/bin
fi
curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer
export PATH="$HOME/.cargo/bin:$PATH"

# Flatpack
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user install flathub md.obsidian.Obsidian -y
flatpak --user install flathub com.mattjakeman.ExtensionManager -y
flatpak --user install flathub io.github.shiftey.Desktop -y
flatpak --user install flathub net.ankiweb.Anki -y
flatpak --user install flathub com.github.marktext.marktext -y
flatpak --user install flathub com.github.tchx84.Flatseal -y
flatpak --user install flathub com.github.neithern.g4music -y
flatpak --user install flathub com.axosoft.GitKraken -y
flatpak --user install flathub io.gitlab.librewolf-community -y
flatpak --user install flathub io.podman_desktop.PodmanDesktop -y

# Doom Emacs
read -rp "Instalar Doom Emacs? (S/N): " DOOM
if [[ $DOOM =~ ^[Ss]$ ]]; then
    if [ -d ~/.emacs.d ]; then
        rm -Rf ~/.emacs.d
    fi
    go install github.com/fatih/gomodifytags@latest
    go install github.com/cweill/gotests/...@latest
    go install github.com/x-motemen/gore/cmd/gore@latest
    go install golang.org/x/tools/cmd/guru@latest
    pip install nose
    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
    sleep 5
    rm -rf ~/.doom.d
fi

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Anaconda
read -rp "Instalar Anaconda3? (S/N): " ANA
if [[ $ANA =~ ^[Ss]$ ]]; then
    wget https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh
    chmod +x Anaconda3-2023.09-0-Linux-x86_64.sh
    ./Anaconda3-2023.09-0-Linux-x86_64.sh
fi

# Bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
sed -i 's/"font"/"powerline"/g' "$HOME/.bashrc"

# ZSH
if [ ! -d ~/.local/share/zsh ]; then
    mkdir -p ~/.local/share/zsh
fi
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/zsh/powerlevel10k

chsh -s /usr/bin/zsh

go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/go-delve/delve/cmd/dlv@latest
pip install black 'python-lsp-server[all]' pyright yamllint autopep8
cargo install taplo-cli --locked
cargo install stylua
sudo npm install -g neovim prettier bash-language-server vscode-langservers-extracted emmet-ls typescript typescript-language-server yaml-language-server live-server markdownlint markdownlint-cli dockerfile-language-server-nodejs stylelint js-beautify
wget https://github.com/artempyanykh/marksman/releases/download/2023-07-25/marksman-linux-x64
mv marksman-linux-x64 marksman
chmod +x marksman
mv marksman "$HOME/.local/bin/"

# Paquetes Nix
# export NIXPKGS_ALLOW_INSECURE=1
export NIXPKGS_ALLOW_UNFREE=1
# nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-env -iA nixpkgs.mysql-workbench
nix-env -iA nixpkgs.wlogout
nix-env -iA nixpkgs.gnome-feeds
nix-env -iA nixpkgs.corectrl
nix-env -iA nixpkgs.lazygit
nix-env -iA nixpkgs.zsh-autosuggestions
nix-env -iA nixpkgs.zsh-syntax-highlighting

jgmenu_run init --theme=archlabs_1803

sleep 5

sudo reboot
