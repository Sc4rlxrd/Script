#!/usr/bin/env bash
set -e
echo "👉 [5/8] Instalando aplicativos gerais..."

# ==========================
# 🧰 Instalar o Yay (AUR helper)
# ==========================
if ! command -v yay &>/dev/null; then
  echo "📦 Yay não encontrado. Instalando..."
  sudo pacman -S --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/yay
else
  echo "✅ Yay já instalado."
fi

# ==========================
# 💻 VS Code (oficial Microsoft build)
# ==========================
echo "💻 Instalando Visual Studio Code (oficial)..."
if yay -Qs visual-studio-code-bin >/dev/null 2>&1; then
  echo "⚙️ VS Code já instalado. Deseja atualizar? (s/n)"
  read -r UPDATE
  if [[ "$UPDATE" =~ ^[sS]$ ]]; then
    yay -Syu --noconfirm visual-studio-code-bin
  else
    echo "✅ Mantendo versão atual do VS Code."
  fi
else
  yay -S --needed --noconfirm visual-studio-code-bin
fi

# ==========================
# 🌐 Navegador Brave (AUR)
# ==========================
echo "🌍 Instalando Brave Browser..."
yay -S --needed --noconfirm brave-bin

# ==========================
# 📦 Flatpak + Aplicativos
# ==========================
echo "📦 Verificando Flatpak..."
if ! command -v flatpak &>/dev/null; then
  sudo pacman -S --needed --noconfirm flatpak
fi

echo "🧩 Adicionando repositório Flathub (caso não exista)..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "🎵 Instalando Spotify via Flatpak..."
flatpak install -y flathub com.spotify.Client

echo "🧪 Instalando Insomnia via Flatpak..."
flatpak install -y flathub rest.insomnia.Insomnia

echo "🗄️ Instalando Beekeeper Studio via Flatpak..."
flatpak install -y flathub io.beekeeperstudio.Studio

echo "✅ [5/8] Todos os aplicativos gerais foram instalados com sucesso!"
