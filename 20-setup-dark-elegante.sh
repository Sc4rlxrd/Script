#!/usr/bin/env bash
# ==========================================================
# Tema escuro, fontes modernas e Kvantum Sweet
# Aplica o wallpaper em todas as áreas de trabalho
# ==========================================================

echo "🖤 Iniciando configuração do tema Dark Elegante para KDE..."

# 1️⃣ Atualizar sistema
echo "📦 Atualizando pacotes..."
sudo pacman -Syu --noconfirm

# 2️⃣ Instalar apenas o essencial
echo "🔠 Instalando fontes e temas..."
sudo pacman -S --noconfirm --needed \
  inter-font \
  ttf-jetbrains-mono \
  kvantum \
  sweet-gtk-theme \
  kvantum-theme-sweet

# 3️⃣ Criar pasta de wallpapers
mkdir -p ~/Imagens/wallpapers
# 4️⃣ Baixar wallpaper com CURL (mais confiável)
WALLPAPER_URL="https://w.wallhaven.cc/full/og/wallhaven-og5jp7.png"
DESTINO_WALLPAPER=~/Imagens/wallpapers/og5jp7.jpg

echo "🖼️ Baixando wallpaper Dark Elegante..."
if curl -L --fail -o "$DESTINO_WALLPAPER" "$WALLPAPER_URL"; then
  echo "✅ Wallpaper baixado com sucesso!"
else
  echo "❌ Falha ao baixar o wallpaper. Verifique sua conexão."
  exit 1
fi

# 5️⃣ Aplicar tema e cores no KDE
echo "⚙️ Aplicando temas e cores..."
kwriteconfig5 --file kdeglobals --group "General" --key "ColorScheme" "Breeze Twilight"
kwriteconfig5 --file kdeglobals --group "KDE" --key "widgetStyle" "Breeze"
kwriteconfig5 --file kdeglobals --group "KScreen" --key "ScaleFactor" "1"

# 6️⃣ Aplicar fontes modernas
echo "🔤 Aplicando fontes..."
kwriteconfig5 --file kdeglobals --group "General" --key "font" "Inter,10,-1,5,50,0,0,0,0,0"
kwriteconfig5 --file kdeglobals --group "WM" --key "activeFont" "Inter SemiBold,11,-1,5,63,0,0,0,0,0"
kwriteconfig5 --file kdeglobals --group "General" --key "fixed" "JetBrains Mono,10,-1,5,50,0,0,0,0,0"

# 7️⃣ Aplicar esquema Kvantum (Sweet)
echo "🧠 Aplicando tema Kvantum Sweet..."
mkdir -p ~/.config/Kvantum
echo "[General]
theme=Sweet" > ~/.config/Kvantum/kvantum.kvconfig

# 8️⃣ Aplicar wallpaper em todas as áreas de trabalho
echo "🌆 Aplicando wallpaper em todas as áreas de trabalho..."
if [ -f "$DESTINO_WALLPAPER" ]; then
  # Script JavaScript para o Plasma Shell
  qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    var allDesktops = desktops();
    for (var i = 0; i < allDesktops.length; i++) {
      d = allDesktops[i];
      d.wallpaperPlugin = 'org.kde.image';
      d.currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
      d.writeConfig('Image', 'file://$DESTINO_WALLPAPER');
    }
  " >/dev/null 2>&1
  echo "✅ Wallpaper aplicado em todas as áreas de trabalho!"
else
  echo "⚠️ Wallpaper não encontrado, pulando essa etapa."
fi

# 9️⃣ Finalização
echo
echo "✨ Tema Dark Elegante aplicado com sucesso!"
echo "🖌️ Fontes: Inter + JetBrains Mono"
echo "🎨 Tema: Breeze Twilight + Sweet Kvantum"
echo "🧩 Ícones: Mantidos (não alterados)"
echo "🌆 Wallpaper: $DESTINO_WALLPAPER"
echo "🔁 Faça logout ou reinicie a sessão para ver todas as alterações."
