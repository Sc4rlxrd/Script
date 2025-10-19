#!/usr/bin/env bash
set -e
echo "👉 [2/8] Instalando e configurando Hyprland..."

sudo pacman -S --needed --noconfirm \
  hyprland waybar wofi mako hyprpaper swayidle swaylock \
  wl-clipboard xdg-desktop-portal-hyprland qt5-wayland qt6-wayland

mkdir -p ~/.config/hypr

cat > ~/.config/hypr/hyprland.conf <<'EOF'
monitor=,preferred,auto,1
exec-once = waybar
exec-once = mako
exec-once = hyprpaper
exec-once = wofi --show drun
bind = SUPER, RETURN, exec, kitty
bind = CTRL_ALT, T, exec, kitty
gaps_in = 6
gaps_out = 6
border_size = 2
EOF

echo "✅ [2/8] Hyprland configurado com sucesso!"
