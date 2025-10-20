# 🧩 Arch/Manjaro Hyprland Setup — Scripts de Instalação Automatizada

Automatize completamente a configuração de um ambiente **Manjaro Minimal / Arch Linux** com **Hyprland**, **ferramentas de desenvolvimento**, **IDE IntelliJ**, **VS Code**, **Docker**, **ZRAM**, **Flatpak**, e muito mais — tudo em scripts modulares e independentes.

---

## ⚙️ Estrutura dos Scripts

| Ordem | Arquivo | Função |
|:--:|:--|:--|
| 1️⃣ | `01-base.sh` | Instala pacotes base, utilitários e ferramentas essenciais |
| 2️⃣ | `02-hyprland.sh` | Instala o Hyprland e dependências Wayland |
| 3️⃣ | `03-devtools.sh` | Instala ferramentas de desenvolvimento (Java, Docker, Terraform, AWS CLI, etc.) |
| 4️⃣ | `04-intellij.sh` | Instala o IntelliJ IDEA Community Edition manualmente |
| 5️⃣ | `05-apps.sh` | Instala VS Code oficial, Brave, Spotify, Insomnia e Beekeeper |
| 6️⃣ | `06-shell.sh` | Aplica configurações personalizadas para ZSH e Bash |
| 7️⃣ | `07-zram.sh` | Configura ZRAM e Swap comprimido com `systemd-zram-generator` |
| 8️⃣ | `08-finish.sh` | Limpa pacotes órfãos e finaliza o setup |
| ⚡ | `hyprland-autologin.sh` | Habilita login automático no Hyprland via SDDM |
| ♻️ | `hyprland-rollback.sh` | Reverte o login automático e restaura o KDE/Plasma |
| 🔍 | `hyprland-check.sh` | Faz diagnóstico do ambiente Hyprland |
| 🧰 | `hyprland-fix.sh` | Repara drivers, portais e sessão do Hyprland |
| 🖥️ | `sddm-fix-session.sh` | Corrige o menu de sessão do SDDM para exibir Hyprland |
| 💾 | `check-zram-status.sh` | Mostra o status atual do ZRAM e swap ativo |

---

## 🚀 Como Usar

### 1️⃣ Clonar o repositório
```bash
git clone https://github.com/seuusuario/hyprland-setup.git
cd hyprland-setup
```
### 2️⃣ Dar permissão de execução
```bash
chmod +x *.sh
```

### 3️⃣ Executar os scripts na ordem recomendada
Execute cada script individualmente **em sequência**:

```bash
./01-base.sh
./02-hyprland.sh
./03-devtools.sh
./04-intellij.sh
./05-apps.sh
./06-shell.sh
./07-zram.sh
./08-finish.sh
```

> 💡 **Dica:** Você pode executar todos em sequência com:
> ```bash
> for i in {01..08}*.sh; do sudo bash "$i"; done
> ```

---

## 🧰 Ferramentas Instaladas

- **Ambiente gráfico:** Hyprland (Wayland)
- **Terminais:** Kitty, Alacritty
- **Desenvolvimento:**
  - Java 21 (OpenJDK)
  - Maven
  - Docker + Docker Compose
  - Terraform
  - AWS CLI
  - Git
- **IDEs:**
  - IntelliJ IDEA Community Edition
  - Visual Studio Code (oficial Microsoft build)
- **Aplicativos:**
  - Brave Browser
  - Spotify (via Flatpak)
  - Insomnia (via Flatpak)
  - Beekeeper Studio (via Flatpak)
- **Performance:**
  - ZRAM configurado via `systemd-zram-generator`
- **Shell:**
  - ZSH e Bash customizados

---

## 🧩 Scripts Adicionais (Utilitários)

| Script | Descrição |
|:--|:--|
| `hyprland-autologin.sh` | Ativa login automático direto no Hyprland via SDDM |
| `hyprland-rollback.sh` | Reverte o autologin e volta para KDE/Plasma |
| `hyprland-check.sh` | Diagnóstico completo do ambiente Hyprland (GPU, portal, Wayland, etc.) |
| `hyprland-fix.sh` | Reinstala drivers gráficos, portais e áudio (PipeWire) |
| `sddm-fix-session.sh` | Corrige o SDDM para mostrar menu de seleção de sessão |
| `check-zram-status.sh` | Mostra estatísticas de uso e compressão do ZRAM |

---

## ⚡ Requisitos

- **Sistema base:** Manjaro Minimal, Manjaro KDE ou Arch Linux  
- **Permissões sudo** ativas  
- **Conexão com a Internet**

---

## 🧠 Recomendações

- Após instalar o Docker, **reinicie ou reabra a sessão** para aplicar o grupo `docker`
- Para testar o Hyprland sem SDDM:
  ```bash
  dbus-run-session Hyprland
  ```
- Para verificar o ZRAM em tempo real:
  ```bash
  watch -n 2 ./check-zram-status.sh
  ```

---

## 🎉 Resultado Final

🔹 Sistema otimizado, leve e pronto para desenvolvimento  
🔹 Ambiente Wayland moderno (Hyprland)  
🔹 Ferramentas dev e IDEs configuradas  
🔹 Swap comprimido ativo via ZRAM  
🔹 Interface de login com seleção de sessão (SDDM)

---

## 🧾 Licença

Distribuído sob a licença **MIT**.  
Sinta-se à vontade para modificar e compartilhar.

---

### ✨ Autor
Desenvolvido por **Guilherme dos Santos**  
💻 *Automação e Setup para Arch/Manjaro Developers*