#!/usr/bin/env bash
# ==========================================================
# Remove Hyprland, Waybar, Mako, Hyprpaper, HyDE configs
# e Blueman (não necessário no KDE)
# Mantém KDE Plasma, Brave e ferramentas de desenvolvimento
# ==========================================================

echo "🧹 Limpando ambiente Hyprland e derivados..."

# 1. Parar processos relacionados
pkill -9 hyprland waybar hyprpaper mako wofi nm-applet blueman-applet 2>/dev/null

# 2. Remover pacotes principais instalados via pacman
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
  alacritty \
  blueman \
  blueman-applet \
  ttf-jetbrains-mono-nerd \
  ttf-font-awesome \
  ttf-fira-code \
  ttf-cascadia-code \
  ttf-hack-nerd \
  noto-fonts-emoji

# 3. Remover pacotes opcionais instalados pelo AUR (se existirem)
if command -v yay &>/dev/null; then
  yay -Rns --noconfirm --needed \
    swww \
    hyprlock \
    hypridle \
    rofi-lbonn-wayland \
    wlogout
fi

# 4. Limpar configurações personalizadas e backups
echo "🗑️ Removendo pastas e backups de configuração do Hyprland..."
rm -rf ~/.config/hypr
rm -rf ~/.config/waybar
rm -rf ~/.config/mako
rm -rf ~/.config/hyprpaper
rm -rf ~/.config/wlogout
rm -rf ~/.config/wofi
rm -rf ~/.config/rofi
rm -rf ~/.cache/hyprland
rm -rf ~/.local/share/hyprland*
rm -rf ~/.local/state/hyprland*
rm -rf ~/Imagens/wallpapers/hyde-dark.jpg
rm -rf ~/Imagens/wallpapers/wallhaven-*.jpg
rm -rf ~/Imagens/wallpapers/hypr-*

# 5. Garantir que hyprland não inicialize em login
echo "🧯 Removendo serviços de sessão do Hyprland..."
systemctl --user disable --now hyprland-session@${USER}.service 2>/dev/null || true

# 6. Atualizar e limpar dependências órfãs
echo "🧽 Limpando pacotes órfãos..."
sudo pacman -Rns --noconfirm $(pacman -Qtdq 2>/dev/null || echo "")

# 7. Mensagem final
echo "✅ Hyprland, Waybar, Mako, Hyprpaper e Blueman removidos com sucesso!"
echo "💡 KDE Plasma, Brave, Docker, Maven, IntelliJ, VSCode, yay, Beekeeper e Insomnia foram mantidos."
echo "🔁 Reinicie a sessão para voltar ao KDE Wayland (X11 também estará disponível no seletor de login)."
