#!/usr/bin/env bash

set -e

echo "👉 [2/8] Instalando Hyprland e dependências básicas..."

# Instala o Hyprland e componentes Wayland essenciais
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
  qt6-wayland

echo "✅ Pacotes principais do Hyprland instalados com sucesso!"
echo

# ==========================================
# Cria o diretório de configuração padrão (se ainda não existir)
# ==========================================
if [ ! -d "$HOME/.config/hypr" ]; then
  echo "📁 Criando diretório de configuração padrão..."
  mkdir -p "$HOME/.config/hypr"
  echo "✅ Diretório criado."
else
  echo "ℹ️  Diretório ~/.config/hypr já existe — mantendo suas configs atuais."
fi

echo
echo "✅ [2/8] Hyprland instalado com sucesso!"
echo "💡 Na primeira inicialização, o Hyprland criará sua configuração padrão automaticamente."
echo "👉 Você pode editar depois em ~/.config/hypr/hyprland.conf"
