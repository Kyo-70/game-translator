# 🚀 Tradutor de Arquivos para Jogos

![Versão](https://img.shields.io/badge/versão-1.2.0-blue?style=for-the-badge)
![Python](https://img.shields.io/badge/python-3.8+-green?style=for-the-badge)

Uma ferramenta de tradução poderosa e inteligente, projetada para facilitar a localização de jogos e mods. Com uma interface moderna e recursos avançados, ela automatiza grande parte do trabalho manual, garantindo consistência, segurança e agilidade.

---

## 📖 Índice

- [✨ Principais Funcionalidades](#-principais-funcionalidades)
- [🏁 Como Começar](#-como-começar)
- [🕹️ Como Usar](#️-como-usar)
- [🗄️ Visualizador de Banco de Dados](#️-visualizador-de-banco-de-dados)
- [🔧 Perfis de Extração](#-perfis-de-extração)
- [⚙️ Configurações e Segurança](#️-configurações-e-segurança)
- [🐛 Solução de Problemas](#-solução-de-problemas)
- [📁 Estrutura do Projeto](#-estrutura-do-projeto)
- [📄 Licença](#-licença)

---

## ✨ Principais Funcionalidades

O tradutor foi construído com foco em eficiência e segurança, oferecendo um conjunto completo de ferramentas para tradutores.

| Emoji | Funcionalidade | Descrição |
| :---: | --- | --- |
| 🖥️ | **Interface Gráfica Moderna** | Desenvolvida em PySide6 com um tema escuro, focada em usabilidade e conforto visual. |
| 📚 | **Memória de Tradução (SQLite)** | Salve suas traduções em um banco de dados local (`.db`). O sistema reutiliza traduções existentes, economizando tempo e custos de API. |
| 🧠 | **Tradução Inteligente** | Reconhece e traduz automaticamente textos com padrões, como `Soldier 1` -> `Soldado 1` ou variações como `Light/Heavy Armor`. |
| ☁️ | **Suporte a Múltiplas APIs** | Integre com DeepL, Google Translate, LibreTranslate e MyMemory para tradução automática em lote. |
| 💰 | **Otimizado para Planos Gratuitos** | O sistema monitora o uso de caracteres e controla a taxa de requisições para não exceder os limites dos planos gratuitos das APIs. |
| 🔧 | **Perfis de Extração (Regex)** | Crie e edite perfis de extração com expressões regulares (Regex) para se adaptar a qualquer estrutura de arquivo `XML` ou `JSON`. |
| 🔬 | **Editor de Regex Integrado** | Uma ferramenta dedicada para criar, testar e gerenciar seus perfis de extração diretamente na aplicação. |
| ⚡ | **Processamento Assíncrono** | A interface permanece responsiva durante operações pesadas, como carregar arquivos grandes ou traduzir em lote, graças ao uso de threads. |
| 🛡️ | **Segurança e Otimização** | Inclui validadores de segurança, monitoramento de uso de CPU/RAM e otimizações para evitar travamentos e garantir estabilidade. |
| 💾 | **Backup Automático** | Cria automaticamente um backup do arquivo original com timestamp antes de salvar as traduções, garantindo que você nunca perca seu trabalho. |
| 📝 | **Sistema de Logs** | Registra todas as operações importantes em arquivos de log diários para facilitar a depuração e o acompanhamento de atividades. |

---

## 🏁 Como Começar

Siga os passos abaixo para configurar e executar o projeto em sua máquina local.

### Pré-requisitos

- **Python 3.8+**
- **pip** (gerenciador de pacotes do Python)

### Instalação

1. **Clone o repositório:**
   ```sh
   git clone https://github.com/Kyo-70/Tradutor_XML-JSON.git
   cd Tradutor_XML-JSON
   ```

2. **Instale as dependências:**
   ```sh
   pip install -r requirements.txt
   ```

3. **Execute o programa:**
   - **Via Python:**
     ```sh
     python src/main.py
     ```
   - **Via PowerShell (Windows):**
     ```sh
     ./EXECUTAR.ps1
     ```

---

## 🕹️ Como Usar

1.  **Abra o Arquivo**: Use o botão `Abrir Arquivo` para carregar um arquivo `XML` ou `JSON`.
2.  **Memória de Tradução**: Crie ou selecione um arquivo de banco de dados (`.db`) para salvar e reutilizar suas traduções.
3.  **Selecione o Perfil**: Escolha um dos perfis de extração da lista. Para arquivos com estrutura customizada, use o `Editor de Perfis`.
4.  **Traduza**: 
    - **Manualmente**: Clique duas vezes na célula da coluna "Tradução" para editar.
    - **Copiar/Colar em Massa**: Use `Ctrl+C` para copiar múltiplas linhas, edite em um editor de texto externo (como Bloco de Notas) e cole de volta com `Ctrl+V`.
    - **Tradução Automática**: Configure sua chave de API (DeepL, Google, etc.) e use o botão `Traduzir com API`.
    - **Tradução Inteligente**: Use o botão `Tradução Inteligente` para preencher automaticamente textos com base na memória de tradução.
5.  **Salve**: Clique em `Salvar Arquivo` para aplicar as traduções. Um backup do arquivo original será criado na pasta `backups/`.

---

## 🗄️ Visualizador de Banco de Dados

Acesse via **Menu > Banco de Dados > Visualizar** ou pelo botão na interface principal:

- **Buscar**: Encontre traduções específicas no seu banco de dados.
- **Filtrar**: Por categoria, para organizar melhor suas traduções.
- **Editar**: Duplo clique para corrigir ou refinar uma tradução salva.
- **Excluir**: Remova entradas incorretas com a tecla `Delete`.
- **Exportar/Importar**: Faça backup ou compartilhe sua memória de tradução em formato `CSV`.

---

## 🔧 Perfis de Extração

O programa já vem com perfis pré-configurados para os formatos mais comuns.

| Nome do Perfil | Tipo de Arquivo | Descrição |
| --- | :---: | --- |
| `JSON Genérico` | `JSON` | Extrai valores de chaves de texto em arquivos JSON. |
| `XML Genérico` | `XML` | Extrai o conteúdo de texto dentro de tags XML. |
| `Bannerlord XML` | `XML` | Perfil específico para arquivos de tradução do Mount & Blade II: Bannerlord. |
| `RimWorld XML` | `XML` | Perfil otimizado para os arquivos de linguagem do RimWorld. |
| `Terminator Dark Fate` | `XML` | Perfil ajustado para os arquivos XML do jogo Terminator: Dark Fate. |

### Criando um Perfil Personalizado

1.  Vá para a pasta `profiles/`.
2.  Crie um novo arquivo `.json` (ex: `meu-jogo.json`).
3.  Use a estrutura abaixo:

```json
{
  "name": "Meu Jogo Especial",
  "description": "Perfil para extrair diálogos do meu jogo.",
  "capture_patterns": [
    "<dialogue>([^<]+)</dialogue>"
  ],
  "exclude_patterns": [
    "<id>.*?</id>"
  ],
  "file_type": "xml"
}
```

4.  Reinicie o programa e seu novo perfil aparecerá na lista!

---

## ⚙️ Configurações e Segurança

### APIs de Tradução

1.  Acesse **"⚙️ Config"** na interface.
2.  Cole sua chave de API (DeepL, Google, etc.).
3.  Selecione a API que deseja usar como ativa.

### Limites de Segurança

O programa possui limites internos para garantir a estabilidade e proteger seu sistema:

| Limite | Valor Padrão | Descrição |
| --- | --- | --- |
| Tamanho Máximo de Arquivo | 100 MB | Previne o carregamento de arquivos excessivamente grandes. |
| Uso Máximo de RAM | 500 MB | Impede que o aplicativo consuma toda a memória do sistema. |
| Uso Máximo de CPU | 80% | Evita sobrecarga do processador. |
| Entradas Máximas por Arquivo | 100.000 | Limita o número de textos extraídos de um único arquivo. |

---

## 🐛 Solução de Problemas

-   **Textos não são extraídos**: Verifique se o perfil de Regex selecionado é compatível com a estrutura do seu arquivo. Tente usar os perfis genéricos ou crie um personalizado.
-   **Programa lento ou travando**: Monitore o uso de RAM e CPU na aba de status. Arquivos muito grandes podem exigir mais recursos. Feche outras aplicações para liberar memória.
-   **Traduções não são salvas na memória**: Certifique-se de que você selecionou ou criou um arquivo de banco de dados (`.db`) no início.

---

## 📁 Estrutura do Projeto

```
Tradutor_XML-JSON/
├── 📄 EXECUTAR.ps1         # Script para execução rápida (PowerShell)
├── 📄 INSTALAR.ps1         # Script de instalação (PowerShell)
├── 📄 requirements.txt      # Dependências do projeto
├── 📄 README.md             # Este arquivo
├── 📁 src/                  # Código-fonte da aplicação
│   ├── main.py              # Ponto de entrada
│   ├── database.py          # Gerenciador da memória de tradução
│   ├── file_processor.py    # Lógica de extração e salvamento
│   ├── smart_translator.py  # Lógica de tradução inteligente
│   ├── translation_api.py   # Integração com APIs externas
│   ├── regex_profiles.py    # Gerenciador de perfis de Regex
│   ├── security.py          # Módulos de segurança e otimização
│   └── gui/                 # Módulos da interface gráfica
│       └── main_window.py   # Janela principal
├── 📁 profiles/             # Perfis de extração salvos em JSON
├── 📁 logs/                 # Arquivos de log gerados
└── 📁 backups/              # Backups automáticos dos arquivos originais
```

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
