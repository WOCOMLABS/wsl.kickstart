#!/bin/bash

# Update and upgrade packages
sudo apt update
sudo apt upgrade -y



# ================================================================================= [ COMMON STUFF ]
sudo apt install curl zip make gcc ripgrep unzip xclip neovim python3 python3-pip -y

sudo ln -s /usr/bin/python3 /usr/bin/python

# Ensure required commands are in PATH
commands=(curl zip make gcc ripgrep unzip xclip neovim python3 python3-pip)
missing=false

for cmd in "${commands[@]}"; do
  if ! command -v $cmd &> /dev/null; then
    echo "$cmd is missing from PATH"
    missing=true
  fi
done

if $missing; then
  echo "Adding /usr/bin and /usr/local/bin to PATH"
  export PATH=$PATH:/usr/local/bin:/usr/bin
fi

# Verify Neovim installation
if command -v nvim &> /dev/null; then
    NEOVIM_STATUS="Installed"
else
    NEOVIM_STATUS="Failed"
fi

# Install additional libraries for Lua build
sudo apt install libreadline-dev -y


# ========================================================================================= [ FONTS ]
# https://github.com/ryanoasis/nerd-fonts/releases make sure you have the latest version


FONT_DIR="$HOME/.local/share/fonts"
mkdir  -p $FONT_DIR

JETBRAINS_MONO_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"
OPENDYSLEXIC_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/OpenDyslexic.zip"

curl -fLo "$FONT_DIR/JetBrainsMono.zip" $JETBRAINS_MONO_URL
curl -fLo "$FONT_DIR/OpenDyslexic.zip" $OPENDYSLEXIC_URL

unzip -o "$FONT_DIR/JetBrainsMono.zip" -d $FONT_DIR/jetbrainsmono
unzip -o "$FONT_DIR/OpenDyslexic.zip" -d $FONT_DIR/opendyslexic

fc-cache -fv

rm "$FONT_DIR/JetBrainsMono.zip"
rm "$FONT_DIR/OpenDyslexic.zip"



# Verify JetBrains Mono Nerd Font installation
if fc-list | grep -iq "JetBrainsMono"; then
    FONT_JETBRAINS_STATUS="Installed"
else
    FONT_JETBRAINS_STATUS="Failed"
fi

# Verify OpenDyslexic Font installation
if fc-list | grep -iq "OpenDyslexic"; then
    FONT_OPENDYSLEXIC_STATUS="Installed"
else
    FONT_OPENDYSLEXIC_STATUS="Failed"
fi



# =========================================================================================== [ ZSH ]
# Install Zsh
sudo apt install zsh -y

# Set Zsh as the default shell
chsh -s $(which zsh)

# Verify Zsh installation
if command -v zsh &> /dev/null; then
    ZSH_STATUS="Installed"
else
    ZSH_STATUS="Failed"
fi

rm -rf ~/.config/share/nvim


# Add alias to .zshrc if not already present
if ! grep -Fxq 'alias vim="nvim"' ~/.zshrc
then
    echo 'alias vim="nvim"' >> ~/.zshrc
fi

# Install Kickstart.nvim
if [ ! -d "$HOME/.config/nvim" ]; then
#    git clone https://github.com/nvim-lua/kickstart.nvim ~/.config/nvim
    git clone https://github.com/WOCOMLABS/kickstart.nvim ~/.config/nvim
fi

# Verify Kickstart.nvim installation
if [ -f "$HOME/.config/nvim/init.lua" ]; then
    KICKSTART_STATUS="Installed"
else
    KICKSTART_STATUS="Failed"
fi



# ======================================================================================= [ STARSHIP ]
# Install Starship prompt
curl -sS https://starship.rs/install.sh | sh

# Add Starship configuration to .zshrc if not already present
if ! grep -Fxq 'eval "$(starship init zsh)"' ~/.zshrc
then
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

# Verify Starship installation
if command -v starship &> /dev/null; then
    STARSHIP_STATUS="Installed"
else
    STARSHIP_STATUS="Failed"
fi



# ====================================================================================== [ JVM STUFF ]
# Install SDKMAN
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Verify SDKMAN installation
if [ -d "$HOME/.sdkman" ]; then
    SDKMAN_STATUS="Installed"
else
    SDKMAN_STATUS="Failed"
fi



# =========================================================================================== [ RUST ]
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# Verify Rust installation
if command -v rustc &> /dev/null; then
    RUST_STATUS="Installed"
else
    RUST_STATUS="Failed"
fi


# ========================================================================================= [ NODEJS ]
# Install NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Ensure NVM is sourced in Zsh sessions
if ! grep -Fxq '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' ~/.zshrc; then
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> ~/.zshrc
fi

# Install Node.js
nvm install 22

# Verify Node.js and NPM installation
if command -v node &> /dev/null; then
    NODE_STATUS="Installed"
else
    NODE_STATUS="Failed"
fi

if command -v npm &> /dev/null; then
    NPM_STATUS="Installed"
else
    NPM_STATUS="Failed"
fi

# ============================================================================== [ Display Results ]
echo
echo "Installation Summary:"
echo "----------------------------------"
printf "%-25s %s\n" "Component" "Status"
echo "----------------------------------"
printf "%-25s %s\n" "JetBrains Mono Font" "$FONT_JETBRAINS_STATUS"
printf "%-25s %s\n" "OpenDyslexic Font" "$FONT_OPENDYSLEXIC_STATUS"
printf "%-25s %s\n" "Zsh" "$ZSH_STATUS"
printf "%-25s %s\n" "Starship Prompt" "$STARSHIP_STATUS"
printf "%-25s %s\n" "SDKMAN" "$SDKMAN_STATUS"
printf "%-25s %s\n" "Neovim" "$NEOVIM_STATUS"
printf "%-25s %s\n" "Neovim Kickstarter" "$KICKSTART_STATUS"
printf "%-25s %s\n" "Rust" "$RUST_STATUS"
printf "%-25s %s\n" "NPM" "$NPM_STATUS"
printf "%-25s %s\n" "Node js" "$NODE_STATUS"
echo "----------------------------------"

exec zsh -c "./init_jvm.sh && ./init_js.sh"