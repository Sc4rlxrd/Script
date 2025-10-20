#!/usr/bin/env bash
# ==========================================
# 🔍 Verificador de ambiente Hyprland
# Feito para Manjaro / Arch Linux
# ==========================================

echo "==> 🔎 Iniciando verificação do ambiente Hyprland..."
echo

# ------------------------------------------
# Função auxiliar
function check_pkg() {
    local pkg="$1"
    if pacman -Q "$pkg" &>/dev/null; then
        echo "✅ $pkg instalado"
    else
        echo "❌ $pkg ausente (sudo pacman -S $pkg)"
    fi
}

# ------------------------------------------
# 1️⃣ Verificar se o Hyprland está instalado
echo "==> Verificando instalação do Hyprland..."
if command -v Hyprland &>/dev/null; then
    echo "✅ Hyprland detectado: $(Hyprland -v | head -n 1)"
else
    echo "❌ Hyprland não encontrado! Instale com:"
    echo "   sudo pacman -S hyprland"
    echo
fi
echo

# ------------------------------------------
# 2️⃣ Verificar dependências críticas
echo "==> Verificando pacotes essenciais..."
check_pkg "dbus"
check_pkg "polkit"
check_pkg "xdg-desktop-portal"
check_pkg "xdg-desktop-portal-hyprland"
check_pkg "xdg-utils"
check_pkg "wl-clipboard"
check_pkg "xdg-user-dirs"
check_pkg "qt5-wayland"
check_pkg "qt6-wayland"
echo

# ------------------------------------------
# 3️⃣ Verificar portal ativo
echo "==> Verificando o serviço do portal..."
if systemctl --user is-active xdg-desktop-portal &>/dev/null; then
    echo "✅ xdg-desktop-portal está em execução"
else
    echo "⚠️  xdg-desktop-portal não está ativo — pode afetar apps Flatpak e GTK"
    echo "💡 Dica: reinicie-o manualmente com: systemctl --user restart xdg-desktop-portal"
fi
echo

# ------------------------------------------
# 4️⃣ Verificar drivers gráficos
echo "==> Verificando drivers gráficos..."
GPU=$(lspci | grep -E "VGA|3D" | cut -d: -f3)
echo "🎮 GPU detectada: $GPU"

if lspci -k | grep -A 2 -E "VGA|3D" | grep -q "amdgpu"; then
    echo "✅ Driver AMDGPU ativo"
elif lspci -k | grep -A 2 -E "VGA|3D" | grep -q "i915"; then
    echo "✅ Driver Intel ativo"
elif lspci -k | grep -A 2 -E "VGA|3D" | grep -q "nouveau"; then
    echo "⚠️  Driver open-source NVIDIA (nouveau) em uso — pode causar instabilidade"
else
    echo "⚠️  Nenhum driver Wayland identificado (verifique se usa mesa, amdgpu ou intel)"
fi
echo

# ------------------------------------------
# 5️⃣ Verificar sessão Wayland
echo "==> Verificando arquivos de sessão Wayland..."
if [[ -f "/usr/share/wayland-sessions/hyprland.desktop" ]]; then
    echo "✅ Sessão hyprland.desktop detectada"
else
    echo "❌ Sessão hyprland.desktop ausente"
    echo "💡 Solução: recrie com:"
    echo "sudo bash -c 'cat > /usr/share/wayland-sessions/hyprland.desktop <<EOF
[Desktop Entry]
Name=Hyprland
Comment=Dynamic tiling Wayland compositor
Exec=env XDG_CURRENT_DESKTOP=Hyprland dbus-run-session Hyprland
Type=Application
DesktopNames=Hyprland
EOF'"
fi
echo

# ------------------------------------------
# 6️⃣ Verificar suporte a áudio
echo "==> Verificando servidores de áudio..."
if systemctl --user is-active pipewire &>/dev/null; then
    echo "✅ PipeWire ativo"
elif systemctl --user is-active pulseaudio &>/dev/null; then
    echo "✅ PulseAudio ativo"
else
    echo "⚠️  Nenhum servidor de áudio detectado"
    echo "💡 Solução: instale pipewire e pipewire-pulse"
fi
echo

# ------------------------------------------
# 7️⃣ Verificar variáveis Wayland
echo "==> Verificando variáveis de ambiente importantes..."
echo "XDG_SESSION_TYPE=${XDG_SESSION_TYPE:-não definida}"
echo "XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP:-não definida}"
echo "WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-não definida}"
echo

# ------------------------------------------
# 8️⃣ Sugestão de correção rápida
echo "==> 💡 Dicas rápidas:"
echo "• Reinicie serviços de portal com: systemctl --user restart xdg-desktop-portal*"
echo "• Verifique logs do Hyprland: journalctl -xe | grep Hypr"
echo "• Teste o Hyprland direto da TTY com: dbus-run-session Hyprland"
echo
echo "✅ Verificação concluída."
