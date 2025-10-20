#!/usr/bin/env bash
set -e
echo "👉 [3/8] Instalando ferramentas de desenvolvimento..."

# ==========================
# 🧰 Instalar pacotes principais
# ==========================
sudo pacman -S --needed --noconfirm \
  jdk21-openjdk maven docker docker-compose terraform aws-cli git

# ==========================
# 🐳 Ativar e iniciar Docker
# ==========================
echo "⚙️  Ativando e iniciando o serviço do Docker..."
sudo systemctl enable --now docker.service

# ==========================
# 👤 Adicionar usuário atual ao grupo Docker
# ==========================
CURRENT_USER=$(whoami)

if groups "$CURRENT_USER" | grep -q '\bdocker\b'; then
  echo "✅ Usuário '$CURRENT_USER' já pertence ao grupo 'docker'."
else
  echo "👤 Adicionando o usuário '$CURRENT_USER' ao grupo 'docker'..."
  sudo usermod -aG docker "$CURRENT_USER"
  echo "⚠️  É necessário encerrar a sessão ou reiniciar para aplicar a mudança de grupo."
fi

echo "✅ [3/8] Ferramentas de desenvolvimento instaladas com sucesso!"
