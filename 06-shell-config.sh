#!/usr/bin/env bash
set -e
echo "👉 [6/8] Aplicando configurações do shell..."

# ZSH
cat > ~/.zshrc <<'EOF'
USE_POWERLINE="true"
HAS_WIDECHARS="false"
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
EOF

# Bash
cat > ~/.bashrc <<'EOF'
# Custom bashrc simplificado com cores
[[ $- != *i* ]] && return
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
PS1='\[\033[01;32m\][\u@\h \W]\$\[\033[00m\] '
EOF

echo "✅ [6/8] Configuração do shell concluída!"
