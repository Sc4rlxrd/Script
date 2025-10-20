#!/usr/bin/env bash
# ==========================================================
# Remove Hyprland, Waybar, Mako, Hyprpaper e HyDE configs
# Mantém KDE Plasma e ferramentas de desenvolvimento
# ==========================================================

echo "🧹 Limpando ambiente Hyprland..."

# 1. Parar processos relacionados
pkill -9 hyprland waybar hyprpaper mako wofi nm-applet blueman-applet 2>/dev/null

# 2. Remover pacotes instalados via pacman
sudo pacman -Rns --noconfirm --needed \
  hyprland \
  waybar \
  mako \
  hyprpaper \
  wofi \
  brightnessctl \
  playerctl \
  network-manager-applet \
  xdg-desktop-portal-hyprland \
  xdg-desktop-portal-gtk \
  kitty \
  ttf-jetbrains-mono-nerd \
  ttf-font-awesome \
  ttf-fira-code \
  ttf-cascadia-code \
  ttf-hack-nerd \
  noto-fonts-emoji

# 3. Remover pacotes extras instalados pelo AUR (caso existam)
if command -v yay &>/dev/null; then
  yay -Rns --noconfirm --needed \
    brave-bin \
    swww \
    hyprlock \
    hypridle \
    rofi-lbonn-wayland \
    wlogout
fi

# 4. Limpar configurações personalizadas
echo "🗑️ Removendo pastas de configuração do Hyprland..."
rm -rf ~/.config/hypr
rm -rf ~/.config/waybar
rm -rf ~/.config/mako
rm -rf ~/.config/hyprpaper
rm -rf ~/.config/wlogout
rm -rf ~/.config/wofi
rm -rf ~/.config/rofi
rm -rf ~/Imagens/wallpapers/hyde-dark.jpg
rm -rf ~/Imagens/wallpapers/wallhaven-*.jpg

# 5. Manter suas ferramentas de dev e o KDE
echo "✅ Mantendo: Docker, Maven, IntelliJ, VSCode, yay, Beekeeper, Insomnia..."
# (nenhuma ação necessária — apenas garantindo que não sejam removidos)

# 6. Atualizar e limpar dependências órfãs
echo "🧽 Limpando pacotes órfãos..."
sudo pacman -Rns --noconfirm $(pacman -Qtdq 2>/dev/null || echo "")

echo "✨ Hyprland e todos os componentes removidos com sucesso!"
echo "Reinicie sua sessão para voltar ao KDE Wayland normalmente."
