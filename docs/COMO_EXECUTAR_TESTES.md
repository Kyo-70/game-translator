# Como Executar os Testes do Commit 0a8a11f

Este documento explica como executar os testes de verificação das mudanças introduzidas no commit 0a8a11f.

## Pré-requisitos

- Python 3.7 ou superior instalado
- Acesso ao diretório raiz do projeto

## Testes Disponíveis

### 1. Teste Completo do Commit 0a8a11f

Verifica todas as mudanças introduzidas no commit:
- Scripts PowerShell (.ps1)
- Correção do bug de paste_rows
- Suporte para Delete múltiplo
- Módulo verificar_sistema.py

```bash
cd src
python test_commit_0a8a11f.py
```

**Saída Esperada**: Todos os 7 testes devem PASSAR

### 2. Teste de Correções Existentes

Testa correções anteriores (paste_rows e window geometry):

```bash
cd src
python test_corrections.py
```

**Nota**: O teste de imports pode falhar se PySide6 não estiver instalado, mas os testes de lógica devem passar.

### 3. Verificação do Sistema

Testa e verifica todas as dependências do projeto:

```bash
cd src
python verificar_sistema.py
```

Para instalar automaticamente dependências faltantes:

```bash
cd src
python verificar_sistema.py --auto-instalar
```

Para modo silencioso (sem interação):

```bash
cd src
python verificar_sistema.py --quiet
```

## Estrutura de Testes

### test_commit_0a8a11f.py

Testes implementados:
1. ✅ **Scripts PowerShell existem** - Verifica criação dos 4 scripts .ps1
2. ✅ **EXECUTAR.ps1 correto** - Valida conteúdo e funcionalidades
3. ✅ **VERIFICAR_SISTEMA.ps1 correto** - Valida script de verificação
4. ✅ **verificar_sistema.py correto** - Valida módulo Python
5. ✅ **Correção paste_rows** - Verifica fix do clipboard_index
6. ✅ **Suporte Delete múltiplo** - Verifica Delete em múltiplas linhas
7. ✅ **_clear_selected_translations** - Verifica limpeza de traduções

### Exemplo de Saída

```
============================================================
🧪 TESTE DO COMMIT 0a8a11f - Tradutor XML-JSON
============================================================

Verificando mudanças do commit:
- Substituir scripts .bat por PowerShell
- Corrigir bugs de seleção múltipla
- Suporte para excluir múltiplas linhas com Delete
- Corrigir bug de colagem em múltiplas linhas

🔍 Testando Scripts PowerShell...
------------------------------------------------------------
✅ EXECUTAR.ps1: encontrado
   ✅ EXECUTAR.ps1: sintaxe PowerShell válida
✅ INSTALAR.ps1: encontrado
...

============================================================
📊 RESUMO DOS TESTES
============================================================
Scripts PowerShell existem: ✅ PASSOU
EXECUTAR.ps1 correto: ✅ PASSOU
VERIFICAR_SISTEMA.ps1 correto: ✅ PASSOU
verificar_sistema.py correto: ✅ PASSOU
Correção paste_rows (clipboard_index): ✅ PASSOU
Suporte Delete múltiplo: ✅ PASSOU
_clear_selected_translations: ✅ PASSOU
============================================================
🎉 TODOS OS TESTES PASSARAM!
```

## Resolução de Problemas

### Teste Falha com "arquivo não encontrado"

Certifique-se de estar executando os testes do diretório correto:
```bash
cd /caminho/para/Tradutor_XML-JSON/src
python test_commit_0a8a11f.py
```

### ImportError para PySide6

Isso é esperado se você não instalou as dependências. Para instalar:
```bash
pip install -r ../requirements.txt
```

Ou use o verificador do sistema:
```bash
python verificar_sistema.py --auto-instalar
```

### PowerShell não disponível

Os testes de sintaxe PowerShell são opcionais. Os testes principais verificam apenas a existência e conteúdo básico dos arquivos .ps1.

## Documentação Adicional

- `docs/TESTE_COMMIT_0a8a11f.md` - Relatório completo dos testes
- `src/test_commit_0a8a11f.py` - Código fonte dos testes
- `src/verificar_sistema.py` - Módulo de verificação do sistema

## Contribuindo com Testes

Para adicionar novos testes:

1. Abra `src/test_commit_0a8a11f.py`
2. Adicione uma nova função `test_nome_do_teste()`
3. Retorne `True` se passou, `False` se falhou
4. Adicione o teste na lista `results` na função `main()`

Exemplo:
```python
def test_minha_funcionalidade():
    """Testa minha nova funcionalidade"""
    print("\n🔍 Testando Minha Funcionalidade...")
    print("-" * 60)
    
    # Seu código de teste aqui
    if condicao_ok:
        print("✅ Teste passou")
        return True
    else:
        print("❌ Teste falhou")
        return False
```

---

**Última atualização**: 2025-12-20
