#!/usr/bin/env bash
set -e
echo "👉 [7/8] Ativando ZRAM e verificando swap..."

sudo pacman -S --needed --noconfirm zram-generator

SWAP_EXIST=$(swapon --show | grep -v "^$" || true)

if [[ -z "$SWAP_EXIST" ]]; then
  echo "Nenhum swap encontrado. Criando swapfile de 2G..."
  sudo fallocate -l 2G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  echo '/swapfile none swap defaults 0 0' | sudo tee -a /etc/fstab
else
  echo "Swap já existente, pulando criação."
fi

sudo systemctl enable --now systemd-zram-setup@zram0.service || true

echo "✅ [7/8] ZRAM e Swap configurados!"
