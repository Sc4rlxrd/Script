#!/usr/bin/env bash
set -e

INSTALL_DIR="/opt/idea-IC"
DESKTOP_FILE="/usr/share/applications/intellij-idea.desktop"
TMP_DIR="/tmp/intellij-install"
URL="https://download.jetbrains.com/idea/ideaIC-latest.tar.gz"

echo "👉 [4/8] Instalando IntelliJ IDEA Community Edition..."

if [[ -d "$INSTALL_DIR" ]]; then
    echo "⚙️ IntelliJ já instalado em: $INSTALL_DIR"
    echo "Deseja atualizar para a versão mais recente? (s/n)"
    read -r UPDATE
    if [[ "$UPDATE" =~ ^[sS]$ ]]; then
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
curl -L "$URL" -o ideaIC.tar.gz

if ! file ideaIC.tar.gz | grep -q gzip; then
    echo "❌ Erro: o arquivo baixado não é um tar.gz válido."
    echo "👉 Verifique se o link da JetBrains ainda é válido."
    exit 1
fi

echo "📂 Extraindo para /opt..."
sudo tar -xzf ideaIC.tar.gz -C /opt/

EXTRACTED_DIR=$(find /opt -maxdepth 1 -type d -name "idea-IC*" | head -n 1)
if [[ -z "$EXTRACTED_DIR" ]]; then
    echo "❌ Erro: não foi possível localizar o diretório extraído."
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

sudo update-desktop-database > /dev/null 2>&1 || true
rm -rf "$TMP_DIR"

echo "✅ IntelliJ IDEA instalado com sucesso!"
