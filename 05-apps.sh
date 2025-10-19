#!/usr/bin/env bash
set -e
echo "👉 [5/8] Instalando aplicativos gerais..."

# Yay (AUR)
if ! command -v yay &>/dev/null; then
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay && makepkg -si --noconfirm
fi

# Brave e Spotify
yay -S --needed --noconfirm brave-bin spotify

# Flatpak e apps Flatpak
sudo pacman -S --needed --noconfirm flatpak
flatpak install -y flathub com.insomnia.Client io.beekeeperstudio.BeekeeperStudio

echo "✅ [5/8] Aplicativos gerais instalados!"
