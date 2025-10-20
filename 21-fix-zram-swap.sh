#!/usr/bin/env bash
# =========================================================
# 🚀 Ativação completa do ZRAM — persistente e automática
# Compatível com Arch / Manjaro / Systemd
# =========================================================
set -euo pipefail
echo "👉 [ZRAM] Iniciando configuração e ativação..."

# 1️⃣ Instalar o pacote correto
if ! pacman -Qi systemd-zram-generator &>/dev/null; then
  echo "⚙️ Instalando systemd-zram-generator..."
  if ! sudo pacman -S --needed --noconfirm systemd-zram-generator; then
    echo "⚠️ Falha ao instalar systemd-zram-generator, tentando zram-generator..."
    sudo pacman -S --needed --noconfirm zram-generator || true
  fi
else
  echo "✅ Pacote systemd-zram-generator já instalado."
fi

# 2️⃣ Carregar módulo do kernel, se necessário
if ! lsmod | grep -q '^zram'; then
  echo "⚙️ Carregando módulo do kernel zram..."
  if ! sudo modprobe zram; then
    echo "❌ Falha ao carregar módulo zram. Kernel pode não ter suporte."
    exit 1
  fi
else
  echo "✅ Módulo zram já carregado."
fi

# 3️⃣ Criar configuração persistente
ZRAM_CONF="/etc/systemd/zram-generator.conf"
echo "⚙️ Criando configuração em $ZRAM_CONF..."
sudo tee "$ZRAM_CONF" >/dev/null <<'EOF'
[zram0]
# Usa metade da memória RAM como swap comprimido
zram-size = ram / 2
compression-algorithm = zstd
EOF
echo "✅ Configuração escrita com sucesso."

# 4️⃣ Limpar ZRAM antigo (se existir)
echo "⚙️ Verificando dispositivos zram existentes..."
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
echo "⚙️ Recarregando systemd e iniciando serviço..."
sudo systemctl daemon-reexec || true
sudo systemctl daemon-reload || true

UNIT="systemd-zram-setup@zram0.service"

# 6️⃣ Ativar agora e também no boot
echo "⚙️ Habilitando serviço para iniciar automaticamente no boot..."
sudo systemctl enable "$UNIT" >/dev/null 2>&1 || true
if sudo systemctl restart "$UNIT"; then
  echo "✅ Serviço $UNIT iniciado com sucesso!"
else
  echo "❌ Falha ao iniciar $UNIT. Exibindo logs:"
  sudo journalctl -u "$UNIT" -b --no-pager | tail -n 50
  exit 1
fi

# 7️⃣ Verificar se o swap ZRAM está ativo
echo
echo "🔍 Verificando swap ativo..."
if swapon --show | grep -q zram; then
  echo "✅ ZRAM está ativo e funcionando!"
  swapon --show
else
  echo "⚠️ ZRAM não aparece como swap ativo. Tentando reativar..."
  sudo systemctl restart "$UNIT"
  sleep 2
  if swapon --show | grep -q zram; then
    echo "✅ ZRAM reativado com sucesso!"
  else
    echo "❌ Falha persistente. Exibindo logs:"
    sudo journalctl -u "$UNIT" -b --no-pager | tail -n 80
    exit 1
  fi
fi

# 8️⃣ Confirma persistência e finaliza
echo
echo "💾 Confirmando persistência..."
if systemctl is-enabled --quiet "$UNIT"; then
  echo "✅ O ZRAM está configurado para iniciar automaticamente em todos os boots!"
else
  echo "⚠️ O serviço ainda não está habilitado. Tentando corrigir..."
  sudo systemctl enable "$UNIT"
  echo "✅ Correção aplicada!"
fi

echo
echo "🎉 ZRAM configurado, ativo e persistente!"
echo "ℹ️ Para verificar manualmente:"
echo "   swapon --show"
echo "   zramctl"
echo "   systemctl status $UNIT"
echo
echo "✅ [ZRAM] Configuração completa e automatizada concluída!"
