#!/usr/bin/env bash
# ==========================================
# 🌀 Habilita login automático no Hyprland via SDDM
# Feito para Manjaro KDE Minimal / Arch
# ==========================================

USER_NAME=$(whoami)
SESSION_DIR="/usr/share/wayland-sessions"
CONFIG_DIR="/etc/sddm.conf.d"
CONFIG_FILE="$CONFIG_DIR/hyprland.conf"
DESKTOP_FILE="$SESSION_DIR/hyprland.desktop"

echo "==> Verificando instalação do Hyprland..."
if ! command -v Hyprland &>/dev/null; then
    echo "❌ Hyprland não encontrado. Instale-o antes de rodar este script."
    exit 1
fi
echo "✅ Hyprland detectado."

echo "==> Verificando sessão Wayland..."
if [[ ! -f "$DESKTOP_FILE" ]]; then
    echo "⚙️  Criando arquivo $DESKTOP_FILE ..."
    sudo bash -c "cat > $DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Hyprland
Comment=Dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
DesktopNames=Hyprland
EOF
    echo "✅ Sessão Hyprland registrada no SDDM."
else
    echo "✅ Sessão Hyprland já existe."
fi

echo "==> Verificando diretório de configuração do SDDM..."
sudo mkdir -p "$CONFIG_DIR"

echo "==> Deseja ativar login automático no Hyprland? (s/n)"
read -r AUTLOGIN

if [[ "$AUTLOGIN" =~ ^[sS]$ ]]; then
    echo "⚙️  Criando arquivo de autologin em $CONFIG_FILE..."
    sudo bash -c "cat > $CONFIG_FILE" <<EOF
[Autologin]
User=$USER_NAME
Session=hyprland.desktop

[General]
Numlock=on
EOF
    echo "✅ Login automático configurado para $USER_NAME no Hyprland."
else
    echo "⚙️  Criando apenas a sessão Hyprland sem autologin..."
    sudo bash -c "cat > $CONFIG_FILE" <<EOF
[General]
Numlock=on
EOF
    echo "✅ Sessão Hyprland adicionada. Escolha manualmente na tela de login."
fi

echo "==> Reiniciando o SDDM..."
sudo systemctl restart sddm

echo "🎉 Concluído! Seu sistema deve abrir o Hyprland agora (ou aparecer como opção na tela de login)."
