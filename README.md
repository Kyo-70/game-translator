# 🎮 Game Translator

Sistema profissional de tradução para arquivos JSON e XML de jogos e mods, com preservação total da estrutura original.

![Version](https://img.shields.io/badge/version-1.2.1-blue)
![Python](https://img.shields.io/badge/python-3.8+-green)
![Platform](https://img.shields.io/badge/platform-Windows%2011-blue)
![License](https://img.shields.io/badge/license-MIT-orange)

## 🚀 Instalação Rápida (Windows)

### Método 1: Instalador Automático (Recomendado)

1. **Baixe** ou extraia todos os arquivos do projeto
2. **Clique com botão direito** em `INSTALAR.ps1` e selecione **"Executar com PowerShell"**
3. **Selecione** a opção `[1] Instalação Completa`
4. **Aguarde** a instalação automática com visual moderno e animações
5. **Pronto!** O executável estará em `dist\GameTranslator.exe`

### Método 2: Execução Direta (Desenvolvimento)

1. Certifique-se de ter Python 3.8+ instalado
2. Execute `EXECUTAR.ps1` (clique com botão direito → "Executar com PowerShell")
3. As dependências serão instaladas automaticamente

## 📋 Arquivos do Instalador

| Arquivo | Descrição |
|---------|-----------|
| `INSTALAR.ps1` | 🚀 Instalador completo com menu interativo e visual moderno |
| `EXECUTAR.ps1` | ▶️ Executa o programa rapidamente com interface animada |
| `VERIFICAR_SISTEMA.ps1` | 🔍 Verifica compatibilidade do sistema com **cores no terminal** |
| `build_exe.ps1` | 🔨 Script para criar o executável standalone |

> **Novo! 🎨** Os scripts PowerShell utilizam **visual moderno com animações**:
> - ✅ **Verde brilhante** para operações bem-sucedidas
> - ❌ **Vermelho brilhante** para erros
> - ⚠️ **Amarelo brilhante** para avisos
> - ℹ️ **Ciano brilhante** para informações
> - 🔷 **Azul brilhante** para seções
> - 🌟 **Branco brilhante** para destaques
> - 💜 **Magenta brilhante** para títulos
> - 🎬 **Animações suaves** e efeitos visuais gradientes

## 🎯 Características Principais

### Tradução Inteligente
- **Preservação Total**: Nunca altera chaves, tags, IDs, variáveis ou formatação
- **Memória de Tradução**: Banco de dados SQLite local e selecionável
- **Padrões Numéricos**: Traduz "Soldier 1" → "Soldado 1" automaticamente aplica a "Soldier 2", "Soldier 3", etc.
- **Reaproveitamento**: Traduções anteriores são aplicadas automaticamente

### Interface Moderna
- **Tema Escuro**: Design profissional e confortável
- **Copiar/Colar**: Ctrl+C e Ctrl+V para editar traduções em massa no Notepad
- **Seleção Múltipla**: Selecione e edite várias linhas simultaneamente
- **Auto-ajuste de Altura**: Linhas da tabela se ajustam automaticamente ao tamanho do conteúdo
- **Ajuste de Colunas**: Arraste as bordas das colunas para ajustar a largura conforme necessário
- **Visualizador de Banco**: Veja, edite e exclua traduções salvas (tecla Delete)
- **Editor de Perfis Regex**: Crie e teste perfis personalizados em tempo real
- **Atalhos de Teclado**: Mais de 10 atalhos para agilizar o trabalho (Ctrl+Z para desfazer!)
- **Progresso em Tempo Real**: Acompanhe o status das operações
- **Monitor de Recursos**: Visualize uso de RAM e CPU

### Segurança e Estabilidade
- **Limite de Memória**: Máximo 500MB de RAM
- **Limite de CPU**: Máximo 80% de uso
- **Validação de Arquivos**: Verifica tamanho e integridade
- **Backup Automático**: Cria backup antes de salvar na pasta `backups/`
- **Organização de Backups**: Todos os backups ficam organizados em uma pasta dedicada
- **Timeout de Operações**: Evita travamentos

### APIs de Tradução
- **DeepL**: API profissional de alta qualidade
- **Google Translate**: Ampla cobertura de idiomas

## 📦 Requisitos do Sistema

| Componente | Mínimo | Recomendado |
|------------|--------|-------------|
| Sistema | Windows 10 | Windows 11 |
| Arquitetura | 64-bit | 64-bit |
| RAM | 4 GB | 8 GB |
| Espaço | 500 MB | 1 GB |
| Python | 3.8 | 3.11+ |

## 📖 Como Usar

### 1. Selecionar Banco de Dados

Ao iniciar, o programa solicita um banco de dados:
- **Criar Novo**: Cria um arquivo `.db` vazio
- **Abrir Existente**: Usa um banco de dados anterior

> 💡 **Dica**: Use bancos diferentes para projetos diferentes!

### 2. Importar Arquivo

1. Clique em **"📁 Importar Arquivo"**
2. Selecione um arquivo `.json` ou `.xml`
3. Escolha o perfil de regex adequado

### 3. Traduzir

| Método | Descrição |
|--------|-----------|
| **Manual** | Duplo clique na célula de tradução |
| **Copiar/Colar** | Ctrl+C para copiar, editar no Bloco de Notas, Ctrl+V para colar |
| **Memória** | Clique em "⚡ Aplicar Memória" (aplica a todas ou apenas às linhas selecionadas) |
| **API** | Clique em "🤖 Traduzir Auto" (traduz todas ou apenas as linhas selecionadas) |

> 💡 **Novo!** Use **Ctrl+C** e **Ctrl+V** para copiar múltiplas linhas e editar no Notepad! Veja [COPIAR_COLAR.md](COPIAR_COLAR.md) para detalhes.

> 💡 **Dica de Tradução Seletiva**: Selecione linhas específicas antes de usar "⚡ Aplicar Memória" ou "🤖 Traduzir Auto" para traduzir apenas essas linhas!

### 4. Salvar

- Clique em **"💾 Salvar"**
- Um backup automático será criado na pasta **`backups/`**
- Os backups ficam organizados no mesmo diretório do arquivo original
- Nome do backup: `[arquivo].backup_[data]_[hora]`

> 💡 **Dica**: Os backups são salvos em uma pasta dedicada para facilitar a organização e recuperação de versões anteriores!

## 🗄️ Visualizador de Banco de Dados

Acesse via **Menu > Banco de Dados > Visualizar** ou botão **"🗄️ Ver Banco"** ou atalho **Ctrl+B**:

- **Buscar**: Encontre traduções específicas
- **Filtrar**: Por categoria
- **Editar**: Duplo clique para editar
- **Excluir**: Remova traduções incorretas (botão 🗑️ ou tecla Delete)
- **Ajustar Colunas**: Arraste as bordas das colunas para ajustar a largura horizontalmente
- **Auto-ajuste Vertical**: As alturas das linhas se ajustam automaticamente ao conteúdo
- **Exportar/Importar**: CSV para backup ou compartilhamento (Ctrl+E para exportar)

## ✨ Editor de Perfis Regex

Crie e teste perfis personalizados com interface visual moderna:

- **Teste em Tempo Real**: Veja os resultados enquanto digita
- **Destacar Capturas**: Visualize o que será extraído
- **Validação Automática**: Detecta erros de sintaxe regex
- **Salvar e Carregar**: Gerencie múltiplos perfis
- **Padrões de Captura e Exclusão**: Configure ambos os tipos

Acesse via **Menu > Ferramentas > Editor de Perfis Regex**

## ⌨️ Atalhos de Teclado

| Atalho | Ação | Descrição |
|--------|------|-----------|
| **Ctrl+C** | Copiar | Copia linhas selecionadas (original + tradução) |
| **Ctrl+V** | Colar | Cola traduções nas linhas selecionadas |
| **Ctrl+Z** | Desfazer | Desfaz última ação (até 50 ações) |
| **Ctrl+O** | Importar | Importar arquivo XML ou JSON |
| **Ctrl+S** | Salvar | Salvar traduções no arquivo |
| **Ctrl+D** | Abrir BD | Abrir banco de dados existente |
| **Ctrl+Shift+N** | Novo BD | Criar novo banco de dados |
| **Ctrl+B** | Ver Banco | Visualizar banco de dados |
| **Ctrl+E** | Exportar | Exportar traduções para CSV |
| **Ctrl+Q** | Sair | Fechar aplicativo |
| **Delete** | Limpar | Limpar traduções das linhas selecionadas |

## 🎮 Perfis Pré-configurados

| Perfil | Jogos/Mods |
|--------|------------|
| JSON Genérico | Qualquer arquivo JSON |
| XML Genérico | Qualquer arquivo XML |
| Bannerlord XML | Mount & Blade II: Bannerlord |
| RimWorld XML | RimWorld e mods |

## ⚙️ Configurações

### APIs de Tradução

1. Acesse **"⚙️ Config"**
2. Cole sua chave de API
3. Selecione a API ativa

**Obter chaves:**
- [DeepL API](https://www.deepl.com/pro-api) (gratuito até 500k caracteres/mês)
- [Google Cloud Translation](https://cloud.google.com/translate)

### Limites de Segurança

| Limite | Valor | Descrição |
|--------|-------|-----------|
| Arquivo máximo | 100 MB | Evita travamentos |
| RAM máxima | 500 MB | Protege o sistema |
| CPU máxima | 80% | Evita aquecimento |
| Entradas máximas | 100.000 | Por arquivo |
| Timeout | 300s | Por operação |

## 📁 Estrutura do Projeto

```
game-translator/
├── 📄 INSTALAR.ps1          # Instalador principal (PowerShell)
├── 📄 EXECUTAR.ps1          # Execução rápida (PowerShell)
├── 📄 VERIFICAR_SISTEMA.ps1 # Verificação de compatibilidade (PowerShell)
├── 📄 build_exe.ps1         # Script para criar executável
├── 📄 requirements.txt      # Dependências Python
├── 📄 README.md             # Este arquivo
├── 📁 src/                  # Código-fonte
│   ├── main.py              # Ponto de entrada
│   ├── database.py          # Memória de tradução
│   ├── file_processor.py    # Processamento de arquivos
│   ├── smart_translator.py  # Tradução inteligente
│   ├── translation_api.py   # APIs de tradução
│   ├── regex_profiles.py    # Perfis de regex
│   ├── security.py          # Segurança e otimização
│   ├── logger.py            # Sistema de logs
│   ├── verificar_sistema.py # Verificação do sistema com cores
│   └── gui/
│       ├── main_window.py   # Interface gráfica principal
│       └── regex_editor.py  # Editor visual de perfis regex
├── 📁 profiles/             # Perfis de regex salvos
├── 📁 bds/                  # Bancos de dados de exemplo
├── 📁 logs/                 # Arquivos de log
├── 📁 docs/                 # Documentação adicional
└── 📁 dist/                 # Executável gerado
    └── GameTranslator.exe
```

## 🛡️ Segurança

O programa implementa múltiplas camadas de proteção:

1. **Validação de Entrada**
   - Sanitização de textos
   - Prevenção de SQL injection
   - Validação de regex (anti-ReDoS)

2. **Proteção de Recursos**
   - Monitor de RAM/CPU em tempo real
   - Garbage collection automático
   - Processamento em chunks

3. **Proteção de Arquivos**
   - Validação de tamanho
   - Backup automático
   - Verificação de integridade

4. **Estabilidade**
   - Timeout em todas operações
   - Tratamento de exceções
   - Recuperação de erros

## 🐛 Solução de Problemas

### Python não encontrado

```
❌ PYTHON NÃO ENCONTRADO!
```

**Solução:**
1. Baixe Python em [python.org](https://www.python.org/downloads/)
2. Durante instalação, marque **"Add Python to PATH"**
3. Reinicie o instalador (execute `INSTALAR.ps1` novamente)

### Erro ao criar executável

```
❌ Erro durante a criação do executável
```

**Solução:**
1. Execute `VERIFICAR_SISTEMA.ps1`
2. Instale dependências faltantes
3. Tente novamente com `build_exe.ps1`

### Programa lento ou travando

**Solução:**
1. Verifique uso de RAM no monitor
2. Feche outros programas
3. Use arquivos menores
4. Aumente memória virtual do Windows

### Traduções não aplicadas

**Solução:**
1. Verifique se o perfil de regex está correto
2. Teste com perfil "Genérico"
3. Crie um perfil personalizado

## 📝 Criar Perfil Personalizado

### Opção 1: Editor Visual (Recomendado) ✨

1. Abra **Menu > Ferramentas > Editor de Perfis Regex**
2. Clique em **"➕ Novo Perfil"**
3. Configure:
   - 📝 **Nome e descrição** do perfil
   - 📄 **Tipo de arquivo** (XML ou JSON)
   - 🎯 **Padrões de captura** (regex para extrair textos)
   - 🚫 **Padrões de exclusão** (regex para ignorar)
4. **Teste em tempo real** com seu arquivo
5. **Salve** o perfil

### Opção 2: Edição Manual 📄

1. Crie arquivo em `profiles/MeuPerfil.json`:

```json
{
  "name": "Meu Perfil",
  "description": "Perfil para meu jogo",
  "file_type": "xml",
  "capture_patterns": [
    "<text>([^<]+)</text>",
    "label=\"([^\"]+)\""
  ],
  "exclude_patterns": [
    "<id>.*?</id>",
    "<!--.*?-->"
  ]
}
```

2. Reinicie o programa
3. Selecione o novo perfil

## 🔄 Atualizações Futuras

- [ ] 🌐 Suporte para YAML e INI
- [ ] 🎨 Editor visual de perfis (✅ Implementado na v1.2.1!)
- [ ] 👥 Modo colaborativo em rede
- [ ] 🔌 Mais APIs de tradução
- [ ] ✍️ Corretor ortográfico integrado
- [ ] 📤 Exportação para formatos de tradução (PO, XLIFF)
- [ ] 🔍 Busca e substituição em massa
- [ ] 📊 Estatísticas detalhadas de tradução

## 📄 Licença

Este projeto é distribuído sob a licença MIT.

## 👨‍💻 Autor

Desenvolvido por **Manus AI**

---

## 🎉 Novidades da Versão 1.2.1

### ✨ Novos Recursos
- **Editor Visual de Perfis Regex**: Crie e teste perfis personalizados em tempo real
- **Atalhos de Teclado Expandidos**: Mais de 10 atalhos para máxima produtividade
- **Desfazer/Refazer**: Ctrl+Z para desfazer até 50 ações
- **Scripts PowerShell Modernizados**: Visual com animações e gradientes coloridos
- **Melhorias no Auto-ajuste**: Células se expandem automaticamente ao editar

### 🔧 Melhorias
- Interface mais responsiva e fluida
- Melhor gerenciamento de memória
- Logs mais detalhados
- Validação aprimorada de regex

### 🐛 Correções
- Correção de problemas de visualização ao editar células
- Melhor compatibilidade com Windows 11
- Estabilidade geral aprimorada

---

## 💡 Dicas Rápidas

> 🎯 **Use bancos separados** para cada projeto de tradução - organize melhor seu trabalho!

> ⚡ **Traduza textos únicos primeiro** - o sistema aprende e aplica automaticamente aos similares

> 💾 **Exporte seu banco regularmente** para backup usando Ctrl+E

> 🔍 **Verifique o perfil de regex** se textos não forem extraídos corretamente

> ⌨️ **Use atalhos de teclado** - Ctrl+C/V para copiar/colar, Ctrl+Z para desfazer!

> 🎨 **Experimente o Editor de Regex** - teste padrões em tempo real antes de usar

> 🗑️ **Tecla Delete limpa traduções** - selecione linhas e pressione Delete para limpar

---

**Nota**: Este software foi projetado para preservar completamente a estrutura dos arquivos originais. Sempre revise as traduções antes de usar em produção.
