#!/bin/bash

# Colors
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RED="\e[31m"
BOLD="\e[1m"
RESET="\e[0m"

# Status/step helper
step() {
    echo -e "\n${BOLD}${BLUE}:: $1...${RESET}"
    sleep 0.3
}

status() {
    echo -e "${GREEN}==> $1${RESET}"
}

warn() {
    echo -e "${YELLOW}>> $1${RESET}"
}

fail() {
    echo -e "${RED}!! $1${RESET}"
}

read -rp $'\nDo you want to proceed ricing? [(yes/No) (y/N)] Default=[No]: ' yn
yn="${yn,,}"  # to lowercase

if [[ -z "$yn" || "$yn" == "n" || "$yn" == "no" ]]; then
    fail "Exiting...\nBye :<"
    exit 0
elif [[ "$yn" == "y" || "$yn" == "yes" ]]; then
    status "GOOD CHOICE!!! :>"
else
    fail "Invalid response. Exiting..."
    exit 1
fi

# Ask for sudo password early
sudo -v

#===============================================================#
#====================== Arch Ricing ============================#
#===============================================================#

#---------- Install Paru AUR Helper ------------#
step "Installing Paru (AUR Helper)"

if ! command -v paru &>/dev/null; then
    status "Paru not found. Building paru from AUR..."

    sudo pacman -S --noconfirm --needed base-devel git

    git clone https://aur.archlinux.org/paru.git ~/paru
    cd ~/paru || exit
    makepkg -si --noconfirm
    cd ~
    rm -rf ~/paru

    status "Paru installed successfully!"
else
    warn "Paru is already installed. Skipping."
fi

#==================== Package Lists ======================#
pacmanPackages=(
    bluez bluez-utils
    git curl wget vim nano
    waybar brightnessctl
    fuzzel swww dunst kitty
    ttf-jetbrains-mono-nerd ttf-iosevka-nerd noto-fonts-cjk
    python-pywal zsh
)

paruPackages=(
    clifm-nerd neofetch
)

#==================== Install Pacman Packages ======================#
step "Installing packages via pacman"

for pcpkg in "${pacmanPackages[@]}"; do
    if pacman -Qi "$pcpkg" &>/dev/null; then
        warn "$pcpkg is already installed. Skipping."
    else
        status "Installing $pcpkg..."
        sudo pacman -S --noconfirm "$pcpkg"
    fi
done

#==================== Install AUR Packages via Paru ======================#
step "Installing packages via paru (AUR)"

for prpkg in "${paruPackages[@]}"; do
    if pacman -Qi "$prpkg" &>/dev/null; then
        warn "$prpkg is already installed. Skipping."
    else
        status "Installing $prpkg..."
        paru -S --noconfirm "$prpkg"
    fi
done

#==================== Default Shell ======================#

step "Setting Zsh as your default shell"

if [[ "$SHELL" != "/bin/zsh" ]]; then
    read -rp $'\nDo you want to make Zsh your default shell? [(yes/No)] ' zyn
    zyn="${zyn,,}"
    if [[ "$zyn" == "y" || "$zyn" == "yes" ]]; then
        chsh -s /bin/zsh
        status "Default shell changed to Zsh. Reboot or re-login to apply."
    else
        warn "Zsh not set as default shell. You can still run it manually with: zsh"
    fi
else
    status "You're already using Zsh."
fi

#==================== Clone Rice Repo ======================#
step "Cloning rice files"

GIT_REPO="https://github.com/neferine/random-ideas.git"
DEST="$HOME/.rice"

if [ ! -d "$DEST" ]; then
    status "Cloning rice repo from $GIT_REPO"
    if git clone "$GIT_REPO" "$DEST"; then
        status "Repo cloned successfully."
    else
        fail "Failed to clone repo. Exiting..."
        exit 1
    fi
else
    warn "Repo already exists at $DEST. Skipping."
fi

#==================== Copying Configs and Wallpapers ======================#
step "Copying rice files"

mkdir -p "$HOME/Pictures"

# Copy wallpapers (overwrite)
if [ -d "$DEST/wallpapers" ]; then
    status "Copying wallpapers..."
    cp -rf "$DEST/wallpapers" "$HOME/Pictures/"
else
    warn "No wallpapers folder found in repo. Skipping."
fi

# Copy .config files (no overwrite)
if [ -d "$DEST/.config" ]; then
    status "Copying configs to ~/.config/"
    cp -rni "$DEST/.config/"* "$HOME/.config/"
else
    warn "No .config directory found in repo. Skipping."
fi

# zshrc copy with backup
if [ -f "$HOME/.zshrc" ]; then
    warn "~/.zshrc exists. Backing up..."
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

if [ -f "$DEST/.zshrc" ]; then
    status "Copying new .zshrc"
    cp -i "$DEST/.zshrc" "$HOME/.zshrc"
else
    warn "No .zshrc found in repo. Skipping."
fi

step "Ricing complete! 🎉 Enjoy your new setup!"

read -rp $'\nDo you want to reboot now to apply everything? [(yes/No)] ' reboot_yn
reboot_yn="${reboot_yn,,}"  # lowercase

if [[ "$reboot_yn" == "y" || "$reboot_yn" == "yes" ]]; then
    status "Rebooting now..."
    sleep 1
    sudo reboot
else
    warn "Reboot skipped. You can reboot later to apply all changes."
fi
