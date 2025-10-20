#!/bin/bash
# ==============================================================
# HyDE Dark - Full Auto Setup for Hyprland (Manjaro KDE Minimal)
# Wallpaper: https://wallhaven.cc/w/og5jp7
# ==============================================================

CONFIG_DIR="$HOME/.config"
WALL_DIR="$HOME/Imagens/wallpapers"
WALL_URL="https://w.wallhaven.cc/full/og/wallhaven-og5jp7.jpg"

echo "🔄 Atualizando pacotes..."
sudo pacman -Syu --noconfirm

echo "📦 Instalando dependências essenciais..."
sudo pacman -S --needed --noconfirm \
  hyprland waybar wofi kitty dolphin blueman \
  brightnessctl playerctl network-manager-applet hyprpaper mako \
  wl-clipboard xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  pipewire wireplumber pipewire-pulse grim slurp swappy \
  ttf-jetbrains-mono-nerd ttf-font-awesome noto-fonts-emoji \
  ttf-fira-code ttf-cascadia-code ttf-hack-nerd

echo "💻 Instalando apps opcionais (VSCode + Brave)..."
if ! command -v yay &> /dev/null; then
  echo "⚙️ yay não encontrado, instalando..."
  sudo pacman -S --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay && makepkg -si --noconfirm
  cd ~
fi
yay -S --needed --noconfirm brave-bin code

echo "🧩 Criando diretórios..."
mkdir -p "$CONFIG_DIR/hypr" "$CONFIG_DIR/waybar" "$CONFIG_DIR/mako" "$WALL_DIR"

echo "🌄 Baixando wallpaper personalizado..."
curl -L "$WALL_URL" -o "$WALL_DIR/hyde-dark.jpg"

echo "⚙️ Gerando configuração do Hyprland..."
cat > "$CONFIG_DIR/hypr/hyprland.conf" <<'EOF'
# Hyprland - HyDE Dark Config (Wallpaper: og5jp7)
monitor=HDMI-A-1,1920x1080@60,0x0,1
monitor=eDP-1,1366x768@60,1920x312,1

exec-once = hyprpaper &
exec-once = waybar &
exec-once = mako &
exec-once = blueman-applet &
exec-once = nm-applet &
exec-once = wofi --show drun &

general {
  gaps_in = 5
  gaps_out = 10
  border_size = 2
  col.active_border = rgba(89b4faee)
  col.inactive_border = rgba(313244aa)
  layout = dwindle
}

decoration {
  rounding = 8
  blur = yes
  blur_size = 6
  blur_passes = 3
  drop_shadow = yes
  shadow_range = 4
  shadow_render_power = 2
  col.shadow = rgba(00000099)
}

animations {
  enabled = yes
  bezier = myBezier, 0.05, 0.9, 0.1, 1.05
  animation = windows, 1, 7, myBezier
  animation = border, 1, 10, default
  animation = fade, 1, 4, default
  animation = workspaces, 1, 6, myBezier
}

input {
  kb_layout = br
  follow_mouse = 1
  touchpad {
    natural_scroll = true
  }
}

env = XCURSOR_SIZE,24
env = HYPRCURSOR_SIZE,24

exec-once = systemctl --user start pipewire pipewire-pulse wireplumber

bind = SUPER,Return,exec,kitty
bind = SUPER,E,exec,dolphin
bind = SUPER,B,exec,brave
bind = SUPER,C,exec,code
bind = SUPER,Q,killactive,
bind = SUPER,M,exit,
bind = SUPER,V,exec,wofi --show drun
bind = SUPER,F,fullscreen,
EOF

echo "🎨 Configurando Waybar..."
cat > "$CONFIG_DIR/waybar/config" <<'EOF'
{
  "layer": "top",
  "position": "top",
  "modules-left": ["hyprland/workspaces", "hyprland/window"],
  "modules-center": ["clock"],
  "modules-right": ["tray", "network", "bluetooth", "battery", "backlight", "pulseaudio"],
  "clock": { "format": "  {:%H:%M    %d/%m/%Y}" },
  "battery": { "format": "{icon} {capacity}%", "format-icons": ["","","","",""] },
  "network": { "format-wifi": "  {essid}", "format-disconnected": "" },
  "bluetooth": { "format": " {status}" },
  "pulseaudio": { "format": "{icon} {volume}%", "format-icons": ["","",""] },
  "tray": { "icon-size": 18 }
}
EOF

cat > "$CONFIG_DIR/waybar/style.css" <<'EOF'
* {
  font-family: "JetBrainsMono Nerd Font", monospace;
  font-size: 11pt;
  border: none;
  min-height: 0;
}

window#waybar {
  background: rgba(25,25,35,0.85);
  color: #D9E0EE;
  border-bottom: 2px solid #89B4FA;
}

#workspaces button.active {
  background: #89B4FA;
  color: #1E1E2E;
}
EOF

echo "🔔 Configurando Mako..."
cat > "$CONFIG_DIR/mako/config" <<'EOF'
font=JetBrainsMono Nerd Font 10
background-color=#1E1E2E
text-color=#D9E0EE
border-color=#89B4FA
border-size=2
border-radius=10
default-timeout=5000
EOF

echo "🖼️ Configurando Hyprpaper..."
cat > "$CONFIG_DIR/hypr/hyprpaper.conf" <<'EOF'
preload = ~/Imagens/wallpapers/hyde-dark.jpg
wallpaper = HDMI-A-1, ~/Imagens/wallpapers/hyde-dark.jpg
wallpaper = eDP-1, ~/Imagens/wallpapers/hyde-dark.jpg
splash = false
EOF

echo "✅ Setup HyDE Dark com wallpaper Wallhaven completo!"
echo "Recarregando Hyprland..."
hyprctl reload || echo "ℹ️ Execute manualmente 'hyprctl reload' após logar no Hyprland."
