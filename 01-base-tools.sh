#!/usr/bin/env bash
set -e
echo "👉 [1/8] Instalando pacotes base e ferramentas essenciais..."

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
  base-devel git wget curl unzip zsh kitty alacritty htop neofetch fastfetch vim nano openssh

echo "✅ [1/8] Base e ferramentas essenciais instaladas com sucesso!"
