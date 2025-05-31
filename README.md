# CLAISS CLI - Ferramenta de Refatoração Inteligente

[English](#english) | [Português](#português)

# English

**CLAISS** is a powerful Ruby-based CLI application designed to help developers refactor codebases with ease. It provides tools for batch renaming, text replacement, and permission management across your projects.

[![Build Status](https://img.shields.io/github/actions/workflow/status/JulioPapel/claiss/ci.yml?branch=main)](https://github.com/JulioPapel/claiss/actions)
[![Gem Version](https://badge.fury.io/rb/claiss.svg)](https://badge.fury.io/rb/claiss)
[![Maintainability](https://api.codeclimate.com/v1/badges/.../maintainability)](https://codeclimate.com/github/JulioPapel/claiss/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/.../test_coverage)](https://codeclimate.com/github/JulioPapel/claiss/test_coverage)

## ✨ Features

- 🔄 Refactor file contents and names in batch
- 🔍 Preview changes before applying them
- 📊 Generate detailed diffs of changes
- 🔒 Fix Ruby file permissions automatically
- 🚀 Fast parallel processing
- 🛡️ Safe refactoring with backup options

## 🚀 Installation

Install the CLAISS gem:

```bash
gem install claiss
```

Or add it to your Gemfile:

```ruby
gem 'claiss', '~> 1.0'
```

## 🛠️ Commands

### Version

Check the CLAISS version:

```bash
$ claiss version
# Or use shortcuts:
$ claiss v
$ claiss -v
$ claiss --version
```

### Refactor

Refactor file contents and names using a JSON dictionary:

```bash
$ claiss refactor <project_path> <json_file> [options]
```

**Options:**
- `--destination, -d`: Specify output directory (default: in-place)
- `--dry-run`: Preview changes without modifying files

**Example:**
```bash
$ claiss refactor my_project refactor_rules.json --dry-run
```

#### JSON Dictionary Format

Create a JSON file with key-value pairs for replacements:

```json
{
  "old_term": "new_term",
  "OldClass": "NewClass",
  "old_method": "new_method"
}
```

### Diff

Preview changes before refactoring:

```bash
$ claiss diff <project_path> <json_file> [options]
```

**Options:**
- `--context=N`: Number of context lines (default: 3)
- `--color=WHEN`: Colorize output (always, never, auto)

### Fix Ruby Permissions

Fix file permissions for Ruby projects:

```bash
$ claiss fix_ruby_permissions <project_path>
```

## 🔍 Example Workflow

1. Create a refactoring plan:
   ```json
   {
     "old_name": "new_name",
     "OldModule": "NewModule",
     "@old_attr": "@new_attr"
   }
   ```

2. Preview changes:
   ```bash
   $ claiss diff my_project changes.json
   ```

3. Apply changes:
   ```bash
   $ claiss refactor my_project changes.json
   ```

## 🛡️ Safety Features

- Creates backups before making changes
- Dry-run mode to preview changes
- Ignores version control directories (`.git/`, `.hg/`)
- Skips binary files by default
- Preserves file permissions

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 👨‍💻 Author

- **Júlio Papel** - [@JulioPapel](https://github.com/JulioPapel)

## 🙏 Acknowledgments

- Thanks to all contributors who have helped improve CLAISS
- Inspired by various open-source refactoring tools

---

# Português

**CLAISS** é uma poderosa ferramenta de linha de comando em Ruby projetada para ajudar desenvolvedores a refatorar bases de código com facilidade. Oferece ferramentas para renomeação em lote, substituição de texto e gerenciamento de permissões em seus projetos.

## ✨ Funcionalidades

- 🔄 Refatoração de conteúdo e nomes de arquivos em lote
- 🔍 Visualização prévia das alterações
- 📊 Geração de relatórios detalhados de diferenças
- 🔒 Correção automática de permissões de arquivos Ruby
- 🚀 Processamento paralelo rápido
- 🛡️ Refatoração segura com opções de backup

## 🚀 Instalação

Instale a gem CLAISS:

```bash
gem install claiss
```

Ou adicione ao seu Gemfile:

```ruby
gem 'claiss', '~> 1.0'
```

## 🛠️ Comandos

### Versão

Verifique a versão do CLAISS:

```bash
$ claiss version
# Ou use os atalhos:
$ claiss v
$ claiss -v
$ claiss --version
```

### Refatorar

Refatore conteúdos e nomes de arquivos usando um dicionário JSON:

```bash
$ claiss refactor <caminho_do_projeto> <arquivo_json> [opções]
```

**Opções:**
- `--destination, -d`: Especifica o diretório de saída (padrão: no local)
- `--dry-run`: Visualiza as alterações sem modificar os arquivos

**Exemplo:**
```bash
$ claiss refactor meu_projeto regras.json --dry-run
```

#### Formato do Dicionário JSON

Crie um arquivo JSON com pares chave-valor para as substituições:

```json
{
  "termo_antigo": "novo_termo",
  "ClasseAntiga": "NovaClasse",
  "metodo_antigo": "novo_metodo"
}
```

### Diferenças

Visualize as alterações antes de refatorar:

```bash
$ claiss diff <caminho_do_projeto> <arquivo_json> [opções]
```

**Opções:**
- `--context=N`: Número de linhas de contexto (padrão: 3)
- `--color=WHEN`: Colorir a saída (always, never, auto)

### Corrigir Permissões

Corrija as permissões de arquivos em projetos Ruby:

```bash
$ claiss fix_ruby_permissions <caminho_do_projeto>
```

## 🔍 Fluxo de Trabalho Exemplo

1. Crie um plano de refatoração:
   ```json
   {
     "nome_antigo": "novo_nome",
     "ModuloAntigo": "NovoModulo",
     "@atributo_antigo": "@novo_atributo"
   }
   ```

2. Visualize as alterações:
   ```bash
   $ claiss diff meu_projeto alteracoes.json
   ```

3. Aplique as alterações:
   ```bash
   $ claiss refactor meu_projeto alteracoes.json
   ```

## 🛡️ Recursos de Segurança

- Cria backups antes de fazer alterações
- Modo de simulação para visualização prévia
- Ignora diretórios de controle de versão (`.git/`, `.hg/`)
- Ignora arquivos binários por padrão
- Preserva as permissões dos arquivos

## 🤝 Como Contribuir

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/feature-incrivel`)
3. Faça commit das suas alterações (`git commit -m 'Adiciona uma feature incrível'`)
4. Faça push para a branch (`git push origin feature/feature-incrivel`)
5. Abra um Pull Request

## 📄 Licença

Distribuído sob a licença MIT. Veja `LICENSE` para mais informações.

## 👨‍💻 Autor

- **Júlio Papel** - [@JulioPapel](https://github.com/JulioPapel)

## 🙏 Agradecimentos

- A todos os contribuidores que ajudaram a melhorar o CLAISS
- Inspirado por várias ferramentas de refatoração open source