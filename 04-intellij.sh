#!/usr/bin/env bash

set -e

INSTALL_DIR="/opt/idea-IC"
DESKTOP_FILE="/usr/share/applications/intellij-idea.desktop"
TMP_DIR="/tmp/intellij-install"
URL="https://www.jetbrains.com/idea/download/download-thanks.html?platform=linux&code=IIC"

echo "👉 [4/8] Verificando IntelliJ IDEA Community Edition..."

# Se já estiver instalado
if [[ -d "$INSTALL_DIR" ]]; then
    echo "⚙️  IntelliJ já instalado em: $INSTALL_DIR"
    echo "Deseja atualizar para a versão mais recente? (s/n)"
    read -r UPDATE
    if [[ "$UPDATE" =~ ^[sS]$ ]]; then
        echo "🔄 Atualizando IntelliJ IDEA Community..."
        sudo rm -rf "$INSTALL_DIR"
    else
        echo "✅ Mantendo a instalação atual."
        exit 0
    fi
fi

echo "📦 Preparando diretório temporário..."
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
cd "$TMP_DIR"

echo "🌐 Baixando IntelliJ IDEA Community Edition..."
wget -q --show-progress "$URL" -O ideaIC.tar.gz

echo "📂 Extraindo para /opt..."
sudo tar -xzf ideaIC.tar.gz -C /opt/

# Detecta o nome da pasta extraída (muda em cada versão)
EXTRACTED_DIR=$(find /opt -maxdepth 1 -type d -name "idea-IC*" | head -n 1)

if [[ -z "$EXTRACTED_DIR" ]]; then
  echo "❌ Erro: não foi possível encontrar o diretório extraído."
  exit 1
fi

sudo mv "$EXTRACTED_DIR" "$INSTALL_DIR"
sudo chmod -R 755 "$INSTALL_DIR"

echo "🧩 Criando atalho de menu..."
sudo tee "$DESKTOP_FILE" > /dev/null <<EOF
[Desktop Entry]
Name=IntelliJ IDEA Community
Comment=IDE para desenvolvimento em Java e outras linguagens
Exec=/opt/idea-IC/bin/idea.sh %f
Icon=/opt/idea-IC/bin/idea.png
Terminal=false
Type=Application
Categories=Development;IDE;
StartupWMClass=jetbrains-idea
EOF

echo "🔄 Atualizando cache de aplicativos..."
sudo update-desktop-database > /dev/null 2>&1 || true

rm -rf "$TMP_DIR"

echo "✅ IntelliJ IDEA Community Edition instalado com sucesso!"
echo "💡 Para abrir manualmente, execute:"
echo "   /opt/idea-IC/bin/idea.sh &"

echo "✅ [4/8] IntelliJ IDEA instalado!"
