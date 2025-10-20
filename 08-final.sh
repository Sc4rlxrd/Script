#!/usr/bin/env bash
set -e
echo "👉 [8/8] Finalizando instalação..."

sudo pacman -Rns --noconfirm $(pacman -Qtdq) || true
sudo pacman -Scc --noconfirm || true

echo ""
echo "🎉 Sistema pronto!"
echo " - Ambiente: KDE + Hyprland"
echo " - Terminal padrão: Kitty (Ctrl+Alt+T)"
echo " - Dev tools: Docker, Java 21, Maven, Terraform, AWS CLI"
echo " - Apps: Brave, Spotify, IntelliJ IDEA, Insomnia, Beekeeper"
echo "✅ Setup completo!"
