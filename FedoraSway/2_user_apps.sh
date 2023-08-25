#!/usr/bin/env bash

R_USER=$(id -u)
if [ "$R_USER" -eq 0 ];
then
   echo "Este script debe usarse con un usuario regular."
   echo "Saliendo..."
   exit 1
fi

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
if [ ! -d ~/.local/bin ]; then
    mkdir -p ~/.local/bin
fi
curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer
export PATH="$HOME/.cargo/bin:$PATH"

xdg-user-dirs-update

# Nerdfonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -f -v
rm JetBrainsMono.zip

# Temas
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme || return
./install.sh -l -i fedora -N glassy
cd ..

git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme || return
./install.sh -t grey
cd ..

git clone https://github.com/vinceliuice/WhiteSur-cursors.git
cd WhiteSur-cursors || return
./install.sh
cd ..

# Tema Ulauncher
mkdir -p ~/.config/ulauncher/user-themes
git clone https://github.com/Raayib/WhiteSur-Dark-ulauncher.git ~/.config/ulauncher/user-themes/WhiteSur-Dark-ulauncher

# Flatpak
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user install flathub fr.handbrake.ghb -y
flatpak --user install flathub md.obsidian.Obsidian -y
flatpak --user install flathub io.github.shiftey.Desktop -y
flatpak --user install flathub net.ankiweb.Anki -y
flatpak --user install flathub com.github.marktext.marktext -y
flatpak --user install flathub com.rafaelmardojai.Blanket -y
flatpak --user install flathub com.github.tchx84.Flatseal -y
flatpak --user install flathub com.github.neithern.g4music -y
flatpak --user install flathub com.axosoft.GitKraken -y
flatpak --user install flathub org.kde.ktouch -y
flatpak --user override --filesystem="$HOME"/.themes
flatpak --user override --env=GTK_THEME=WhiteSur-Dark

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

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Anaconda
# wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh
# chmod +x Anaconda3-2022.10-Linux-x86_64.sh
# ./Anaconda3-2022.10-Linux-x86_64.sh

# Jetbrains
# if [ ! -d ~/Apps ]; then
#     mkdir ~/Apps
# fi
# cd ~/Apps || return
# wget https://download.jetbrains.com/python/pycharm-professional-2022.3.tar.gz
# wget https://download.jetbrains.com/datagrip/datagrip-2022.3.1.tar.gz
# wget https://download.jetbrains.com/cpp/CLion-2022.3.tar.gz
# tar -xzf pycharm-professional-2022.3.tar.gz
# tar -xzf datagrip-2022.3.1.tar.gz
# tar -xzf CLion-2022.3.tar.gz
# rm pycharm-professional-2022.3.tar.gz
# rm datagrip-2022.3.1.tar.gz
# rm CLion-2022.3.tar.gz
# cd ~ || return


# Android
# if [ ! -d ~/Apps ]; then
#     mkdir ~/Apps
# fi
# cd ~/Apps || return
# wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.3.1.17/android-studio-2021.3.1.17-linux.tar.gz
# tar -xzf android-studio-2021.3.1.17-linux.tar.gz
# rm android-studio-2021.3.1.17-linux.tar.gz
# cd ~/Apps || return
# wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.3.9-stable.tar.xz
# tar xf flutter_linux_3.3.9-stable.tar.xz
# rm flutter_linux_3.3.9-stable.tar.xz
# cd ~ || return

pip install black 'python-lsp-server[all]' pyright yamllint autopep8
cargo install taplo-cli --locked
cargo install stylua
sudo npm install -g neovim prettier bash-language-server vscode-langservers-extracted emmet-ls typescript typescript-language-server yaml-language-server live-server markdownlint markdownlint-cli dockerfile-language-server-nodejs stylelint js-beautify

jgmenu_run init --theme=archlabs_1803

sleep 5

reboot

