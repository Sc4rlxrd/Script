#!/usr/bin/env bash
# =========================================================
# 🔍 check-zram-status.sh — Verifica e mostra status do ZRAM
# Compatível com: Manjaro / Arch / Systemd
# =========================================================

set -euo pipefail

echo "🔍 Verificando status do ZRAM..."

# 1️⃣ Verifica se o módulo zram está carregado
if ! lsmod | grep -q '^zram'; then
  echo "⚠️  O módulo zram não está carregado!"
  echo "💡 Dica: execute 'sudo modprobe zram' ou rode o script fix-zram.sh novamente."
  exit 1
else
  echo "✅ Módulo zram carregado no kernel."
fi

# 2️⃣ Mostra dispositivos zram detectados
echo
echo "📦 Dispositivos ZRAM detectados:"
if compgen -G "/dev/zram*" > /dev/null; then
  zramctl || echo "⚠️  O utilitário zramctl não está disponível (instale 'util-linux')."
else
  echo "❌ Nenhum dispositivo zram encontrado."
  echo "💡 Dica: verifique se o serviço systemd-zram-setup@zram0.service está ativo."
fi

# 3️⃣ Verifica se está sendo usado como swap
echo
echo "💾 Status de swap:"
if swapon --show | grep -q zram; then
  swapon --show
else
  echo "⚠️  Nenhum swap ZRAM ativo."
  echo "💡 Dica: execute 'sudo systemctl restart systemd-zram-setup@zram0.service'."
fi

# 4️⃣ Mostra estatísticas úteis de compressão
echo
if [[ -d /sys/block/zram0 ]]; then
  echo "📊 Estatísticas de compressão (/sys/block/zram0):"
  echo "-----------------------------------------------"
  for stat in compr_data_size orig_data_size mem_used_total; do
    if [[ -f /sys/block/zram0/$stat ]]; then
      VAL=$(cat /sys/block/zram0/$stat)
      echo "$stat: $((VAL / 1024 / 1024)) MB"
    fi
  done
  echo "-----------------------------------------------"
else
  echo "⚠️  Diretório /sys/block/zram0 não encontrado — serviço pode não estar ativo."
fi

# 5️⃣ Mostrar status do serviço systemd
echo
echo "🧩 Status do serviço systemd-zram-setup@zram0:"
if systemctl is-active --quiet systemd-zram-setup@zram0.service; then
  echo "✅ Serviço ativo e em execução."
else
  echo "❌ Serviço inativo. Logs recentes:"
  sudo journalctl -u systemd-zram-setup@zram0.service -b --no-pager | tail -n 20
fi

echo
echo "🎉 Diagnóstico concluído!"
echo "👉 Dica: use 'watch -n 2 ./check-zram-status.sh' para monitorar em tempo real."
