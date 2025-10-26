#!/bin/bash
set -e

# Instala o Hyprland, componentes Wayland essenciais e o terminal Kitty
sudo pacman -S --needed --noconfirm \
  hyprland \
  waybar \
  wofi \
  mako \
  hyprpaper \
  swayidle \
  swaylock \
  wl-clipboard \
  xdg-desktop-portal-hyprland \
  qt5-wayland \
  qt6-wayland \
  kitty \
  blueman \
  blueman-applet
echo "✅ Pacotes principais do Hyprland e o terminal Kitty instalados com sucesso!"
echo

echo "✅ [2/8] Instalação dos programas concluída!"
echo "💡 Na primeira inicialização, o Hyprland criará sua configuração padrão automaticamente."
echo "👉 Você pode editar depois em ~/.config/hypr/hyprland.conf"