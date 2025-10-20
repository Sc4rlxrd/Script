#!/usr/bin/env bash
# ==========================================
# 🌀 Corrigido — habilita login automático no Hyprland via SDDM
# Suporte total para Manjaro KDE Minimal / Arch
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

# ------------------------------------------
# Corrige o .desktop para incluir o env wrapper
# ------------------------------------------
echo "==> Verificando sessão Wayland..."
if [[ ! -f "$DESKTOP_FILE" ]]; then
    echo "⚙️  Criando arquivo $DESKTOP_FILE ..."
    sudo bash -c "cat > $DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Hyprland
Comment=Dynamic tiling Wayland compositor
Exec=env XDG_CURRENT_DESKTOP=Hyprland dbus-run-session Hyprland
Type=Application
DesktopNames=Hyprland
EOF
    echo "✅ Sessão Hyprland registrada no SDDM."
else
    echo "✅ Sessão Hyprland já existe. (verificando conteúdo)"
    if ! grep -q "dbus-run-session" "$DESKTOP_FILE"; then
        echo "⚙️  Atualizando Exec para usar dbus-run-session..."
        sudo sed -i 's|^Exec=.*|Exec=env XDG_CURRENT_DESKTOP=Hyprland dbus-run-session Hyprland|' "$DESKTOP_FILE"
    fi
fi

# ------------------------------------------
# Verifica dependências críticas
# ------------------------------------------
echo "==> Verificando dependências essenciais..."
missing_pkgs=()

for pkg in dbus polkit xdg-desktop-portal-hyprland xdg-desktop-portal; do
    if ! pacman -Q "$pkg" &>/dev/null; then
        missing_pkgs+=("$pkg")
    fi
done

if (( ${#missing_pkgs[@]} > 0 )); then
    echo "⚠️  Instalando dependências ausentes: ${missing_pkgs[*]}"
    sudo pacman -Sy --noconfirm "${missing_pkgs[@]}"
else
    echo "✅ Todas as dependências estão presentes."
fi

# ------------------------------------------
# Configura o SDDM
# ------------------------------------------
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

# ------------------------------------------
# Finaliza
# ------------------------------------------
echo "==> Reiniciando o SDDM..."
sudo systemctl restart sddm

echo "🎉 Concluído! Seu sistema deve abrir o Hyprland agora (ou aparecer como opção na tela de login)."
