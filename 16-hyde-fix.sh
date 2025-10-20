#!/bin/bash
# ==============================================================
# HyDE Dark - Fix / Light Setup for Hyprland (Safe version)
# Wallpaper: https://wallhaven.cc/w/og5jp7
# ==============================================================

CONFIG_DIR="$HOME/.config"
WALL_DIR="$HOME/Imagens/wallpapers"
WALL_URL="https://w.wallhaven.cc/full/og/wallhaven-og5jp7.jpg"
WALL_FILE="$WALL_DIR/hyde-dark.jpg"

echo "🧩 Corrigindo configuração HyDE Dark..."
mkdir -p "$CONFIG_DIR/hypr" "$CONFIG_DIR/waybar" "$CONFIG_DIR/mako" "$WALL_DIR"

echo "🌄 Baixando wallpaper..."
curl -L "$WALL_URL" -o "$WALL_FILE"

echo "🖼️ Configurando Hyprpaper..."
cat > "$CONFIG_DIR/hypr/hyprpaper.conf" <<EOF
preload = $WALL_FILE
wallpaper = HDMI-A-1, $WALL_FILE
wallpaper = eDP-1, $WALL_FILE
splash = false
EOF

echo "⚙️ Corrigindo configuração do Waybar..."
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

# Verifica e corrige autostart no Hyprland
if ! grep -q "hyprpaper" "$CONFIG_DIR/hypr/hyprland.conf" 2>/dev/null; then
  echo "📜 Ajustando hyprland.conf..."
  cat >> "$CONFIG_DIR/hypr/hyprland.conf" <<'EOF'

# HyDE autostart fix
exec-once = hyprpaper &
exec-once = waybar &
exec-once = mako &
EOF
fi

echo "✅ Tudo pronto! Recarregando serviços..."
pkill hyprpaper 2>/dev/null
pkill waybar 2>/dev/null
pkill mako 2>/dev/null
sleep 1
hyprpaper &
waybar &
mako &

echo "🌙 HyDE Dark aplicado com sucesso!"
