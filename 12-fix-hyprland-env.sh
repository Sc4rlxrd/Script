#!/usr/bin/env bash
# ==========================================
# 🧰 Script de reparo de ambiente Hyprland (Manjaro/Arch)
# ==========================================

set -e

echo "==> Detectando GPU..."
GPU=$(lspci | grep -E "VGA|3D")
echo "GPU detectada: $GPU"
echo

# ==========================================
# 1️⃣ Instala drivers adequados
# ==========================================
echo "==> Instalando drivers essenciais (AMD, Mesa, Vulkan, VAAPI)..."
sudo pacman -S --needed --noconfirm \
    mesa \
    vulkan-radeon \
    libva-mesa-driver \
    mesa-vdpau \
    libva-utils \
    vulkan-tools \
    wayland \
    xdg-desktop-portal \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-hyprland \
    pipewire pipewire-alsa pipewire-pulse wireplumber \
    qt5-wayland qt6-wayland

echo "✅ Drivers e bibliotecas Wayland instalados."
echo

# ==========================================
# 2️⃣ Corrige sessão Hyprland no SDDM
# ==========================================
SESSION_FILE="/usr/share/wayland-sessions/hyprland.desktop"
if [[ ! -f "$SESSION_FILE" ]]; then
    echo "⚙️  Criando sessão Hyprland..."
    sudo bash -c "cat > $SESSION_FILE" <<EOF
[Desktop Entry]
Name=Hyprland
Comment=Dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
DesktopNames=Hyprland
EOF
    echo "✅ Sessão Hyprland registrada."
else
    echo "✅ Sessão Hyprland já existe."
fi
echo

# ==========================================
# 3️⃣ Reinicia serviços de portal e áudio
# ==========================================
echo "==> Reiniciando serviços de portal e áudio..."
systemctl --user restart pipewire pipewire-pulse wireplumber || true
systemctl --user restart xdg-desktop-portal xdg-desktop-portal-hyprland || true
echo "✅ Portais e PipeWire reiniciados."
echo

# ==========================================
# 4️⃣ Teste de ambiente Wayland
# ==========================================
echo "==> Verificando ambiente Wayland..."
if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
    echo "✅ Wayland já ativo ($XDG_SESSION_TYPE)"
else
    echo "⚠️  Você está em sessão X11. Hyprland só roda em Wayland."
fi
echo

# ==========================================
# 5️⃣ Oferece teste direto do Hyprland
# ==========================================
echo "==> Deseja testar o Hyprland agora direto do TTY? (s/n)"
read -r RESPOSTA
if [[ "$RESPOSTA" =~ ^[sS]$ ]]; then
    echo "⚙️  Iniciando sessão Hyprland..."
    echo "👉 Para sair, pressione Ctrl+Alt+Backspace ou Ctrl+C"
    sleep 2
    dbus-run-session Hyprland
else
    echo "✅ Ok. Reinicie o sistema e selecione 'Hyprland' no SDDM."
fi

echo
echo "🎉 Reparo concluído!"
