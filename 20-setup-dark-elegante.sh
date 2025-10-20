#!/usr/bin/env bash
# ==========================================================
# 🎨 KDE Dark Elegante Setup
# Aplica tema, fontes e ícones modernos ao KDE Plasma
# Mantém leve, limpo e 100% compatível com Wayland e X11
# ==========================================================

echo "🖤 Iniciando configuração do tema Dark Elegante para KDE..."

# 1. Atualizar sistema
echo "📦 Atualizando pacotes..."
sudo pacman -Syu --noconfirm

# 2. Instalar fontes e temas necessários
echo "🔠 Instalando fontes e temas..."
sudo pacman -S --noconfirm --needed \
  inter-font \
  ttf-jetbrains-mono \
  papirus-icon-theme \
  kvantum \
  sweet-gtk-theme \
  kvantum-theme-sweet

# 3. Criar pasta de wallpapers, se não existir
mkdir -p ~/Imagens/wallpapers

# 4. Baixar wallpaper Dark Elegante
WALLPAPER_URL="https://w.wallhaven.cc/full/og/wallhaven-og5jp7.jpg"
echo "🖼️ Baixando wallpaper Dark Elegante..."
wget -q "$WALLPAPER_URL" -O ~/Imagens/wallpapers/og5jp7.jpg

# 5. Aplicar tema e ícones no KDE (via kdeglobals)
echo "⚙️ Aplicando temas e ícones..."
kwriteconfig5 --file kdeglobals --group "Icons" --key "Theme" "Papirus-Dark"
kwriteconfig5 --file kdeglobals --group "General" --key "ColorScheme" "Breeze Twilight"
kwriteconfig5 --file kdeglobals --group "KDE" --key "widgetStyle" "Breeze"
kwriteconfig5 --file kdeglobals --group "KScreen" --key "ScaleFactor" "1"

# 6. Aplicar fontes
echo "🔤 Aplicando fontes..."
kwriteconfig5 --file kdeglobals --group "General" --key "font" "Inter,10,-1,5,50,0,0,0,0,0"
kwriteconfig5 --file kdeglobals --group "WM" --key "activeFont" "Inter SemiBold,11,-1,5,63,0,0,0,0,0"
kwriteconfig5 --file kdeglobals --group "General" --key "fixed" "JetBrains Mono,10,-1,5,50,0,0,0,0,0"

# 7. Aplicar esquema Kvantum (Sweet)
echo "🧠 Aplicando tema Kvantum Sweet..."
mkdir -p ~/.config/Kvantum
echo "[General]
theme=Sweet" > ~/.config/Kvantum/kvantum.kvconfig

# 8. Aplicar wallpaper
echo "🌆 Aplicando wallpaper principal..."
plasma-apply-wallpaperimage ~/Imagens/wallpapers/og5jp7.jpg 2>/dev/null || true

# 9. Finalização
echo "✨ Tema Dark Elegante aplicado com sucesso!"
echo "🔁 Faça logout ou reinicie a sessão para ver todas as alterações."
echo "🖌️ Fontes: Inter + JetBrains Mono"
echo "🎨 Tema: Breeze Twilight + Sweet Kvantum"
echo "🧩 Ícones: Papirus Dark"
