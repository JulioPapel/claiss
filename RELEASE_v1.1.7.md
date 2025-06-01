# CLAISS v1.1.7 - Melhorias na Renomeação de Arquivos Binários

## 🚀 Novas Funcionalidades

- Adicionada opção `--debug` para exibir mensagens detalhadas durante o processamento
- Melhor suporte para renomeação de arquivos binários (imagens, PDFs, etc.)
- Verificação de permissões e existência de arquivos aprimorada

## 🐛 Correções de Bugs

- Corrigido o carregamento de dicionários de substituição a partir do diretório `~/.claiss/`
- Melhor tratamento de erros durante o processamento de arquivos binários
- Corrigida a ordenação de substituições para evitar problemas com chaves parciais

## 📚 Melhorias na Documentação

- Adicionados exemplos mais claros de uso no README
- Documentação atualizada sobre o suporte a arquivos binários
- Adicionada seção explicando como usar a opção `--debug`

## 🔧 Melhorias Técnicas

- Refatoração do código para melhor manutenibilidade
- Adicionados logs detalhados para facilitar a depuração
- Melhor tratamento de exceções e mensagens de erro

## 📦 Como Atualizar

```bash
gem update claiss
```

Ou, se estiver usando Bundler, atualize sua Gemfile:

```ruby
gem 'claiss', '~> 1.1.7'
```

## 📋 Notas de Uso

Agora você pode usar a opção `--debug` para obter informações detalhadas durante o processamento:

```bash
# Modo normal
$ claiss refactor meu_projeto regras.json

# Com mensagens de debug
$ claiss refactor meu_projeto regras.json --debug
```

Para arquivos binários, a ferramenta agora:
1. Detecta corretamente arquivos binários por extensão
2. Aplica as substituições apenas nos nomes dos arquivos
3. Mantém o conteúdo original dos arquivos intacto

## 🙏 Agradecimentos

Obrigado a todos que contribuíram com relatórios de bugs e sugestões de melhoria!
