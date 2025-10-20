#!/usr/bin/env bash
set -e
echo "👉 [7/8] Ativando ZRAM e verificando swap..."

set -euo pipefail

echo "👉 Iniciando configuração e teste do ZRAM..."

# 1️⃣ Instalar pacote correto
if ! pacman -Qi systemd-zram-generator &>/dev/null; then
  echo "⚙️  Instalando systemd-zram-generator..."
  if ! sudo pacman -S --needed --noconfirm systemd-zram-generator; then
    echo "⚠️  Falha ao instalar systemd-zram-generator, tentando zram-generator..."
    sudo pacman -S --needed --noconfirm zram-generator || true
  fi
else
  echo "✅ Pacote systemd-zram-generator já instalado."
fi

# 2️⃣ Carregar módulo do kernel se necessário
if ! lsmod | grep -q '^zram'; then
  echo "⚙️  Carregando módulo do kernel zram..."
  if ! sudo modprobe zram; then
    echo "❌ Falha ao carregar módulo zram. Kernel pode não ter suporte."
    exit 1
  fi
else
  echo "✅ Módulo zram já carregado."
fi

# 3️⃣ Criar configuração padrão segura
ZRAM_CONF="/etc/systemd/zram-generator.conf"
echo "⚙️  Criando configuração em $ZRAM_CONF..."
sudo tee "$ZRAM_CONF" >/dev/null <<'EOF'
[zram0]
# Usa metade da memória RAM como swap comprimido
zram-size = ram / 2
compression-algorithm = zstd
EOF
echo "✅ Configuração escrita com sucesso."

# 4️⃣ Limpar zram antigo se houver
echo "⚙️  Verificando dispositivos zram existentes..."
set +e
EXIST=$(ls /dev/zram* 2>/dev/null || true)
if [[ -n "$EXIST" ]]; then
  echo "📦 Dispositivos antigos detectados: $EXIST"
  for d in /dev/zram*; do
    if [[ -b "$d" ]]; then
      sudo swapoff "$d" 2>/dev/null || true
      echo 1 | sudo tee /sys/block/"$(basename "$d")"/reset >/dev/null 2>&1 || true
    fi
  done
else
  echo "✅ Nenhum dispositivo zram anterior detectado."
fi
set -e

# 5️⃣ Recarregar systemd e ativar serviço
echo "⚙️  Recarregando systemd e iniciando serviço..."
sudo systemctl daemon-reexec || true
sudo systemctl daemon-reload || true

UNIT="systemd-zram-setup@zram0.service"
if sudo systemctl enable --now "$UNIT"; then
  echo "✅ Serviço $UNIT iniciado com sucesso!"
else
  echo "❌ Falha ao iniciar $UNIT. Exibindo logs para diagnóstico:"
  sudo journalctl -u "$UNIT" -b --no-pager | tail -n 50
  exit 1
fi

# 6️⃣ Verificar se o swap ZRAM está ativo
echo
echo "🔍 Verificando swap ativo..."
if swapon --show | grep -q zram; then
  echo "✅ ZRAM está ativo:"
  swapon --show
else
  echo "⚠️  ZRAM não aparece como swap ativo. Exibindo logs:"
  sudo journalctl -u "$UNIT" -b --no-pager | tail -n 80
  exit 1
fi

echo
echo "🎉 ZRAM configurado e funcionando com sucesso!"
echo "Você pode confirmar a compressão em tempo real com:"
echo "  cat /proc/swaps"
echo "  zramctl"


echo "✅ [7/8] ZRAM e Swap configurados!"
