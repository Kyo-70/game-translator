# Guia de Uso: Copiar e Colar Traduções

## Nova Funcionalidade: Copiar e Colar

O Game Translator agora suporta copiar e colar traduções, facilitando a edição em massa usando aplicativos externos como o Bloco de Notas (Notepad).

## Como Usar

### Copiar Traduções (Ctrl+C)

1. **Selecione uma ou mais linhas** na tabela de traduções:
   - Clique em uma linha para selecionar uma única linha
   - Use **Ctrl+Clique** para selecionar múltiplas linhas não consecutivas
   - Use **Shift+Clique** para selecionar um intervalo de linhas
   
2. **Pressione Ctrl+C** para copiar as linhas selecionadas

3. O formato copiado é **texto separado por tabulação** (TSV):
   ```
   Texto Original[TAB]Tradução
   Texto Original 2[TAB]Tradução 2
   ```

### Colar Traduções (Ctrl+V)

1. **Selecione as linhas de destino** onde você quer colar as traduções

2. **Pressione Ctrl+V** para colar

3. As traduções serão aplicadas na ordem das linhas selecionadas

## Fluxo de Trabalho Recomendado

### Edição em Massa no Notepad

1. **Selecione as linhas** que deseja traduzir na tabela
   - Exemplo: Selecione linhas 1-10 usando Shift+Clique

2. **Copie as linhas** (Ctrl+C)

3. **Abra o Bloco de Notas** (Notepad) e **cole** (Ctrl+V)
   - Você verá algo como:
   ```
   Hello	Olá
   World	Mundo
   Game	Jogo
   ```

4. **Edite as traduções** no Notepad:
   - Modifique apenas a parte após o TAB (a tradução)
   - Você também pode adicionar traduções vazias
   - Mantenha cada tradução em uma linha separada

5. **Selecione e copie** todo o conteúdo editado no Notepad (Ctrl+A, Ctrl+C)

6. **Volte ao Game Translator** e **selecione as mesmas linhas** (ou outras)

7. **Cole as traduções** (Ctrl+V)
   - As traduções serão aplicadas automaticamente
   - O sistema salvará na memória de tradução

## Formatos Aceitos para Colar

O sistema aceita diferentes formatos:

### Formato Completo (Original + Tradução)
```
Hello	Olá
World	Mundo
```

### Formato Simples (Apenas Traduções)
```
Olá
Mundo
```
Neste caso, as traduções serão aplicadas na ordem das linhas selecionadas.

## Características

- ✅ **Seleção múltipla**: Selecione quantas linhas quiser
- ✅ **Ordem preservada**: As traduções são coladas na ordem de seleção
- ✅ **Compatível com Notepad**: Formato TSV funciona perfeitamente
- ✅ **Compatível com Excel**: Você também pode editar no Excel
- ✅ **Memória automática**: Traduções coladas são salvas na memória
- ✅ **Validação**: O sistema valida os dados antes de colar
- ✅ **Feedback visual**: Status atualizado após copiar/colar

## Atalhos de Teclado

| Atalho | Ação |
|--------|------|
| **Ctrl+C** | Copiar linhas selecionadas |
| **Ctrl+V** | Colar traduções |
| **Ctrl+A** | Selecionar todas as linhas |
| **Shift+Clique** | Selecionar intervalo |
| **Ctrl+Clique** | Adicionar linha à seleção |

## Exemplos Práticos

### Exemplo 1: Traduzir 10 Linhas no Notepad

1. Selecione linhas 1-10 (Shift+Clique)
2. Copie (Ctrl+C)
3. Abra Notepad e cole (Ctrl+V)
4. Edite as traduções após o TAB
5. Copie tudo do Notepad (Ctrl+A, Ctrl+C)
6. Volte ao Game Translator e selecione as mesmas linhas 1-10
7. Cole (Ctrl+V)

### Exemplo 2: Copiar Apenas Algumas Traduções

1. Selecione linhas específicas com Ctrl+Clique (ex: 1, 5, 8, 12)
2. Copie (Ctrl+C)
3. As 4 linhas serão copiadas no formato TSV
4. Cole em qualquer aplicativo ou arquivo de texto

### Exemplo 3: Colar de Outra Fonte

1. Copie traduções de um arquivo de texto externo
2. No Game Translator, selecione as linhas de destino
3. Cole (Ctrl+V)
4. As traduções serão aplicadas automaticamente

## Avisos Importantes

⚠️ **Número de Linhas**: Se você copiar 5 linhas mas selecionar 10 linhas para colar, apenas as primeiras 5 linhas receberão as traduções.

⚠️ **Formato**: Mantenha o formato de separação por TAB para melhor funcionamento. O sistema também aceita apenas traduções (uma por linha).

⚠️ **Linhas Vazias**: Traduções vazias serão ignoradas ao colar.

## Mensagens do Sistema

Após copiar ou colar, você verá mensagens na barra de status:
- "X linha(s) copiada(s)" - Indica quantas linhas foram copiadas
- "X tradução(ões) colada(s)" - Indica quantas traduções foram aplicadas
- "Área de transferência vazia" - Não há dados para colar
- "Nenhuma linha selecionada" - Selecione linhas antes de copiar/colar

## Integração com Outras Funcionalidades

As traduções coladas são:
- ✅ Salvas automaticamente na memória de tradução
- ✅ Usadas pelo sistema de tradução inteligente
- ✅ Incluídas nas estatísticas de progresso
- ✅ Registradas nos logs do sistema
