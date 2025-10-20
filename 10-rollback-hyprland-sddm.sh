#!/usr/bin/env bash
# ==========================================
# ♻️ Reverte as alterações de login automático do Hyprland no SDDM
# Feito para Manjaro KDE Minimal / Arch
# ==========================================

CONFIG_FILE="/etc/sddm.conf.d/hyprland.conf"
DESKTOP_FILE="/usr/share/wayland-sessions/hyprland.desktop"
PLASMA_SESSION="/usr/share/wayland-sessions/plasma.desktop"

echo "==> Iniciando rollback das configurações Hyprland no SDDM..."

# 1️⃣ Remover configuração de autologin
if [[ -f "$CONFIG_FILE" ]]; then
    echo "🧹 Removendo arquivo de configuração do SDDM ($CONFIG_FILE)..."
    sudo rm -f "$CONFIG_FILE"
else
    echo "⚠️ Nenhum arquivo de configuração de autologin encontrado."
fi

# 2️⃣ Restaurar sessão padrão para Plasma (KDE)
if [[ -f "$PLASMA_SESSION" ]]; then
    echo "🔄 Ajustando sessão padrão de login para KDE Plasma..."
    sudo bash -c "cat > /etc/sddm.conf.d/plasma.conf" <<EOF
[Autologin]
User=$(whoami)
Session=plasma.desktop

[General]
Numlock=on
EOF
    echo "✅ Sessão padrão redefinida para KDE Plasma."
else
    echo "⚠️ Sessão do KDE não encontrada, talvez esteja usando outra interface."
fi

# 3️⃣ (Opcional) Pergunta se quer remover o .desktop do Hyprland
if [[ -f "$DESKTOP_FILE" ]]; then
    echo "❓ Deseja remover o arquivo de sessão do Hyprland ($DESKTOP_FILE)? (s/n)"
    read -r REMOVE
    if [[ "$REMOVE" =~ ^[sS]$ ]]; then
        sudo rm -f "$DESKTOP_FILE"
        echo "🗑️ Arquivo de sessão do Hyprland removido."
    else
        echo "✅ Mantendo o arquivo de sessão do Hyprland."
    fi
else
    echo "⚠️ Arquivo de sessão do Hyprland não encontrado."
fi

# 4️⃣ Reiniciar o SDDM
echo "🔁 Reiniciando o SDDM..."
sudo systemctl restart sddm

echo "🎉 Rollback completo! O sistema deve iniciar no KDE Plasma novamente."
