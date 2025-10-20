#!/usr/bin/env bash
# ==========================================================
# 🧹 Remoção total do Hyprland, configs e sessões residuais
# Mantém KDE Plasma (Wayland + X11), Brave e ferramentas dev
# ==========================================================

echo "🧹 Limpando completamente o Hyprland e seus componentes..."

# 1. Parar processos relacionados
pkill -9 hyprland waybar hyprpaper mako wofi nm-applet blueman-applet 2>/dev/null

# 2. Remover pacotes principais instalados pelo pacman
sudo pacman -Rns --noconfirm \
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

# 3. Remover pacotes opcionais via AUR (se existirem)
if command -v yay &>/dev/null; then
  yay -Rns --noconfirm --needed \
    swww \
    hyprlock \
    hypridle \
    rofi-lbonn-wayland \
    wlogout
fi

# 4. Apagar configurações e backups
echo "🗑️ Removendo configurações e resíduos do Hyprland..."
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

# 5. Remover arquivos de sessão
echo "🧯 Removendo entradas de sessão do Hyprland..."
sudo rm -f /usr/share/wayland-sessions/hyprland.desktop
sudo rm -f /usr/share/xsessions/hyprland.desktop

# 6. Desativar serviços relacionados ao Hyprland
systemctl --user disable --now hyprland-session@${USER}.service 2>/dev/null || true

# 7. Limpar pacotes órfãos
echo "🧽 Limpando dependências órfãs..."
sudo pacman -Rns --noconfirm $(pacman -Qtdq 2>/dev/null || echo "")

# 8. Verificar se ainda existem arquivos de sessão do Hyprland
echo "🔍 Verificando se ainda há sessões Hyprland registradas..."
SESSION_FILES=$(grep -R "Hyprland" /usr/share/*sessions/ 2>/dev/null)
if [ -n "$SESSION_FILES" ]; then
  echo "⚠️ Encontrado(s) arquivo(s) de sessão Hyprland:"
  echo "$SESSION_FILES"
  echo "🧨 Removendo arquivos detectados..."
  echo "$SESSION_FILES" | cut -d: -f1 | sort -u | sudo xargs rm -f 2>/dev/null
else
  echo "✅ Nenhum arquivo de sessão Hyprland restante."
fi

# 9. Reinstalar portal do KDE para garantir integração Wayland
echo "🔧 Reinstalando integração Wayland do KDE..."
sudo pacman -S --needed --noconfirm xdg-desktop-portal-kde xdg-desktop-portal

# 10. Mensagem final
echo "✅ Hyprland, Waybar, Mako, Hyprpaper e dependências removidos com sucesso!"
echo "💡 KDE Plasma, Brave, Docker, Maven, IntelliJ, VSCode, yay, Beekeeper e Insomnia foram mantidos."
echo "🔁 Reinicie o sistema. Apenas 'Plasma (Wayland)' e 'Plasma (X11)' devem aparecer no seletor de login."
