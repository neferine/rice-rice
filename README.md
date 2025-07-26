# 🍚 rice-rice

> rice is good , good is rice. do it rice 🍚

---

## 📦 What is this?

**rice-rice** is a personal script that automates the setup of my custom riced Arch Linux environment. It installs essential packages, clones my dotfiles repo, and safely applies my preferred Wayland setup with wallpapers, fonts, and config files — all in one go.

---

## 🧠 Features

- 🔧 Installs essential packages via `pacman` and `paru`
- 🧩 Applies Wayland-based rice (Hyprland/Waybar/Fuzzel/swww)
- 🖼️ Overwrites wallpapers automatically to `~/Pictures`
- 📁 Interactive and safe config copying to `~/.config`
- 🐚 Installs and configures `zsh` with a custom `.zshrc`
- 🧠 Backup system for existing `.zshrc` before replacement
- ✅ Interactive prompt before proceeding (default = No)

---

## 🚀 Installation Guide

```bash
git clone https://github.com/neferine/rice-rice.git
cd rice-rice
chmod +x rice.sh
./rice.sh
