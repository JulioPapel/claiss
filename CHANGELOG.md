# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/spec/v2.0.0.html).

## [1.1.5] - 2025-06-01

### Adicionado
- Novo comando `diff` para visualizar alterações antes de aplicar refatorações
- Suporte a modo `--dry-run` no comando `refactor`
- Opção `--context` para controlar o número de linhas de contexto nas diferenças
- Documentação completa em português e inglês
- Badges de status no README
- Seção de agradecimentos aos contribuidores

### Melhorado
- Refatoração do código para melhor manutenção
- Mensagens de log mais descritivas
- Tratamento de erros mais robusto
- Desempenho ao processar múltiplos arquivos

### Corrigido
- Problemas ao lidar com diretórios vazios
- Erros ao processar arquivos com caracteres especiais
- Corrigida a formatação do README

## [1.0.0] - 2025-05-31

### Adicionado
- Versão inicial do CLAISS
- Comandos básicos: `version`, `refactor`, `fix_ruby_permissions`
- Suporte a dicionários JSON para refatoração
- Processamento em paralelo para melhor desempenho
- Documentação inicial

---

## Notas de Versão

### Convenções de Versionamento

- **MAJOR**: Mudanças incompatíveis com versões anteriores
- **MINOR**: Novas funcionalidades compatíveis com versões anteriores
- **PATCH**: Correções de bugs e melhorias de desempenho

### Política de Manutenção

- A versão mais recente do MAJOR recebe atualizações de segurança e correções críticas
- Versões mais antigas podem receber correções críticas de segurança caso necessário

## Links Úteis

- [Repositório](https://github.com/JulioPapel/claiss)
- [Documentação](https://github.com/JulioPapel/claiss#readme)
- [Relatar um problema](https://github.com/JulioPapel/claiss/issues)
