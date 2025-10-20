#!/usr/bin/env bash
set -e
echo "👉 [5/8] Instalando aplicativos gerais..."

# ==========================
# 🧰 Instalar o Yay (AUR helper)
# ==========================
if ! command -v yay &>/dev/null; then
  echo "📦 Yay não encontrado. Instalando..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/yay
else
  echo "✅ Yay já instalado."
fi

# ==========================
# 🌐 Navegador e música (AUR)
# ==========================
echo "🎵 Instalando Brave e Spotify..."
yay -S --needed --noconfirm brave-bin spotify

# ==========================
# 📦 Flatpak + Aplicativos
# ==========================
echo "📦 Verificando Flatpak..."
if ! command -v flatpak &>/dev/null; then
  sudo pacman -S --needed --noconfirm flatpak
fi

echo "🧩 Adicionando repositório Flathub (caso não exista)..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "💻 Instalando aplicativos Flatpak..."
flatpak install -y flathub rest.insomnia.Insomnia
flatpak install -y flathub io.beekeeperstudio.Studio

echo "✅ [5/8] Aplicativos gerais instalados com sucesso!"
