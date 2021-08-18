#!/bin/bash
PIC="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"

if [ -z "$1" ]
  then
    PIC="$(gsettings get org.gnome.desktop.background picture-uri | sed -e "s/^'//" -e "s/'$//" | awk -F'^file://' '{print $2}')"
    echo "No wallpaper provided, using current wallpaper\n$PIC"
fi

echo "Installing kitty and dependencies..."
sudo apt-get install git imagemagick kitty python3 python3-pip -y &> /dev/null
echo "Installing pywal for theming"
sudo pip3 install pywal &> /dev/null
cd /tmp
echo "Installing cursor..."
wget "https://github.com/ful1e5/Bibata_Cursor/releases/download/v1.1.2/Bibata-Modern-Classic.tar.gz"
tar -xvf Bibata-Modern-Classic.tar.gz
sudo mv Bibata-* /usr/share/icons/
sudo update-alternatives --install /usr/share/icons/default/index.theme x-cursor-theme /usr/share/icons/Bibata-Modern-Classic/index.theme 50
sudo update-alternatives --set x-cursor-theme /usr/share/icons/Bibata-Modern-Classic/index.theme
echo "Installing fonts...(Dauert minimal xd)"
sleep 2
git clone https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
sudo ./install.sh -S FiraMono
sudo ./install.sh -S FiraCode
rm -rf /tmp/nerd-fonts
cd $HOME
if [ ! -d "$HOME/.config/kitty" ]; then
    echo "Creating $HOME/.config/kitty directory..."
    mkdir $HOME/.config/kitty -p
fi
if [ -f "$HOME/.config/kitty/kitty.conf" ]; then
    echo "Deleting default kitty.conf..."
    rm $HOME/.config/kitty/kitty.conf
fi
echo "Parsing config to $HOME/.config/kitty/kitty.conf..."
echo "include ~/.cache/wal/colors-kitty.conf             " > $HOME/.config/kitty/kitty.conf
echo "font_family      FiraCode Nerd Font Mono           " >> $HOME/.config/kitty/kitty.conf
echo "bold_font        auto                              " >> $HOME/.config/kitty/kitty.conf
echo "italic_font      auto                              " >> $HOME/.config/kitty/kitty.conf
echo "bold_italic_font auto                              " >> $HOME/.config/kitty/kitty.conf
echo "                                                   " >> $HOME/.config/kitty/kitty.conf
echo "font_size 16.0                                     " >> $HOME/.config/kitty/kitty.conf
echo "                                                   " >> $HOME/.config/kitty/kitty.conf
echo "disable_ligatures never                            " >> $HOME/.config/kitty/kitty.conf
echo "                                                   " >> $HOME/.config/kitty/kitty.conf
echo "scrollback_lines 2000                              " >> $HOME/.config/kitty/kitty.conf
echo "                                                   " >> $HOME/.config/kitty/kitty.conf
echo "background_opacity 0.9                             " >> $HOME/.config/kitty/kitty.conf
echo "                                                   " >> $HOME/.config/kitty/kitty.conf
echo "allow_remote_control yes                           " >> $HOME/.config/kitty/kitty.conf
echo "                                                   " >> $HOME/.config/kitty/kitty.conf
echo "window_padding_width 5 10                          " >> $HOME/.config/kitty/kitty.conf
echo "Installing starship prompt..."
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
if [ ! "$(grep -q 'eval "$(starship init bash)"' $HOME/.bashrc)" ]; then
  echo 'eval "$(starship init bash)"' >> $HOME/.bashrc
fi
echo 'add_newline = false' > $HOME/.config/starship.toml
echo '[character]        ' >> $HOME/.config/starship.toml
echo 'success_symbol = ""' >> $HOME/.config/starship.toml
echo '# error_symbol = "[✗](red)"' >> $HOME/.config/starship.toml
echo 'vicmd_symbol = "" ' >> $HOME/.config/starship.toml
echo '[username]         ' >> $HOME/.config/starship.toml
echo 'show_always = true ' >> $HOME/.config/starship.toml
echo '[directory]        ' >> $HOME/.config/starship.toml
echo 'read_only = "  "  ' >> $HOME/.config/starship.toml
echo 'read_only_style = "red"' >> $HOME/.config/starship.toml
echo '[package]          ' >> $HOME/.config/starship.toml
echo 'symbol = " "      ' >> $HOME/.config/starship.toml
echo '[rust]             ' >> $HOME/.config/starship.toml
echo '# symbol = " "    ' >> $HOME/.config/starship.toml

wal -i $PIC
ln -sf $HOME/.config/kitty/colors-kitty.conf $HOME/.cache/wal/colors-kitty.conf
echo "Setting kitty as new default terminal..."
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
echo "Done!"
