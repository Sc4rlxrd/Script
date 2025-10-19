#!/usr/bin/env bash
set -e
echo "👉 [4/8] Baixando e instalando IntelliJ IDEA Community..."

cd /tmp
wget -q https://download.jetbrains.com/idea/ideaIC-latest.tar.gz -O ideaIC.tar.gz
sudo tar -xzf ideaIC.tar.gz -C /opt/
sudo mv /opt/idea-IC* /opt/idea-IC

sudo tee /usr/share/applications/intellij-idea.desktop > /dev/null <<'EOF'
[Desktop Entry]
Name=IntelliJ IDEA Community
Exec=/opt/idea-IC/bin/idea.sh
Icon=/opt/idea-IC/bin/idea.png
Type=Application
Categories=Development;IDE;
EOF

echo "✅ [4/8] IntelliJ IDEA instalado!"
