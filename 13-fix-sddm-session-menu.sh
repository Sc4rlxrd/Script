#!/usr/bin/env bash
# ==========================================
# 🖥️  Corrige SDDM para exibir menu de sessão (Hyprland / Plasma)
# Feito para Manjaro KDE / Arch Linux
# ==========================================

set -e

echo "==> Corrigindo configuração do SDDM..."

# ==========================================
# 1️⃣ Desativa autologin e recria arquivo principal
# ==========================================
SDDM_CONF="/etc/sddm.conf"

echo "⚙️  Recriando $SDDM_CONF..."
sudo bash -c "cat > $SDDM_CONF" <<EOF
[Autologin]
User=
Session=

[Theme]
Current=breeze

[General]
Numlock=on

[Users]
HideShells=/usr/bin/nologin,/bin/false
EOF

echo "✅ Autologin desativado e menu de sessão habilitado."
echo

# ==========================================
# 2️⃣ Garante que a sessão Hyprland esteja registrada
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
    echo "✅ Sessão Hyprland criada."
else
    echo "✅ Sessão Hyprland já existe."
fi

echo

# ==========================================
# 3️⃣ Reinicia o serviço do SDDM
# ==========================================
echo "==> Reiniciando o SDDM..."
sudo systemctl restart sddm || {
    echo "⚠️  Falha ao reiniciar o SDDM. Reinicie o sistema manualmente com 'sudo reboot'."
    exit 0
}

echo
echo "🎉 Concluído!"
echo "➡️  Agora, na tela de login do SDDM, clique na ⚙️ e selecione 'Hyprland'."
echo "➡️  Faça login normalmente para entrar no Hyprland."
