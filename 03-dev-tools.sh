#!/usr/bin/env bash
set -e
echo "👉 [3/8] Instalando ferramentas de desenvolvimento..."

sudo pacman -S --needed --noconfirm \
  jdk21-openjdk maven docker docker-compose terraform aws-cli git

sudo systemctl enable --now docker.service

echo "✅ [3/8] Ferramentas de desenvolvimento instaladas!"
