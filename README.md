# 🧠 Tradutor_XML-JSON

![Status](https://img.shields.io/badge/status-ativo-4CAF50?style=for-the-badge)
![Python](https://img.shields.io/badge/Python-3.8%2B-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Interface](https://img.shields.io/badge/UI-PySide6-1A9FFF?style=for-the-badge)
![APIs](https://img.shields.io/badge/APIs-Google%2FDeepL%2FMyMemory%2FLibre-673ab7?style=for-the-badge)
![Downloads](https://img.shields.io/badge/Downloads-Automático-009688?style=for-the-badge)
![Licença](https://img.shields.io/badge/Licença-MIT-FFB300?style=for-the-badge)
![Arquitetura](https://img.shields.io/badge/Arquitetura-Modular-795548?style=for-the-badge)
![Tradução](https://img.shields.io/badge/Formato-XML%20%7C%20JSON-7E57C2?style=for-the-badge)
![Build](https://img.shields.io/badge/Build-Manual-616161?style=for-the-badge)

---

## 🎨 Visão Geral

**Tradutor_XML-JSON** é uma ferramenta avançada para tradução de arquivos XML e JSON utilizados em jogos e mods.  
Oferece uma interface gráfica moderna, memória de tradução inteligente, perfis customizáveis para extração de texto e integração com diversas APIs.

Um ambiente criado para tradutores, modders e desenvolvedores que precisam de velocidade, precisão e organização.

---

# 🌟 Funcionalidades Principais

## 🧠 Memória de Tradução (SQLite)
- Armazena traduções anteriores.  
- Evita retrabalho.  
- Mantém consistência entre arquivos.  
- Indexação inteligente para pesquisas rápidas.

## 🌐 Suporte a múltiplas APIs
- Google Translate  
- DeepL  
- MyMemory  
- LibreTranslate  
- Módulo preparado para plugins de novas APIs

## 🎯 Perfis Avançados de Extração
Perfis baseados em **Regex**, permitindo:
- Extração precisa de frases  
- Exclusão de elementos indesejados  
- Adaptação para cada estrutura de jogo  

### Perfis incluídos:
- **Bannerlord**  
- **RimWorld**  
- **Terminator: Dark Fate – Defiance**

## 🛡 Backups Automáticos
Antes de sobrescrever:  
✔ Cria backup  
✔ Gera logs  
✔ Mantém histórico seguro

## ⚙️ Interface Moderna
- PySide6  
- Tema escuro  
- Controles fluidos  
- Layout modular

## 🚀 Processamento Assíncrono
O programa permanece responsivo mesmo durante:
- Extração  
- Processamento  
- Tradução massiva  

---

# 🧭 Instalação

## 📌 Pré-requisitos
- Python **3.8+**
- Pip atualizado
- Pacotes do `requirements.txt`

## 📥 Instalar dependências

```bash
pip install -r requirements.txt
```

## 📥 Instalar via PowerShell (Windows)

```powershell
./INSTALAR.ps1
```

---

# ▶️ Como Executar

### Pelo Python:
```bash
python src/main.py
```

### Pelo PowerShell:
```powershell
./EXECUTAR.ps1
```

---

# 📂 Estrutura do Projeto

```
Tradutor_XML-JSON/
├── src/
│   ├── main.py
│   ├── database.py
│   ├── file_processor.py
│   ├── smart_translator.py
│   ├── translation_api.py
│   ├── regex_profiles.py
│   └── gui/
│       └── main_window.py
├── profiles/
├── logs/
├── backups/
├── requirements.txt
├── EXECUTAR.ps1
├── INSTALAR.ps1
└── README.md
```

---

# 🔧 Como Criar seus Próprios Perfis

Um perfil é um arquivo JSON no formato:

```json
{
    "extract": ["regex aqui"],
    "exclude": ["regex aqui"],
    "description": "Descrição do perfil"
}
```

Você pode criar quantos perfis quiser para:
- Jogos  
- Engines  
- Modpacks  
- Estruturas XML/JSON específicas  

---

# 📘 Documentação de APIs

Cada API possui configuração própria.  
Acesse no menu:

**Configurações → APIs**

Informações que pode inserir:
- Chave  
- Endpoint  
- Limite de requisições  
- Modo gratuito/pago  

---

# 💡 Dicas de Uso

- Utilize memória para manter consistência entre arquivos.  
- Crie perfis distintos para cada jogo.  
- Ative logs detalhados ao depurar.  
- Nunca edite arquivos de jogo sem backup.  
- Mantenha Regex limpos e bem documentados.  

---

# 🤝 Contribuindo

Pull Requests são bem-vindos!

Para contribuir:
1. Faça um Fork  
2. Crie uma branch com sua mudança  
3. Documente o que alterou  
4. Envie o PR com clareza  

---

# 📄 Licença

Este projeto está sob a **MIT License**.

---
