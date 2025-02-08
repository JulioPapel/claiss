# CLAISS CLI Refactor Application Toolbox

[English](#english) | [Português](#português)

# English

**CLAISS** is a Ruby-based CLI application and toolbox designed to manage CLAISS Refactored applications and deployments. Please note that some features may have limited compatibility depending on the environment. Use with caution!

## Installation

Install the CLAISS gem by running the following command in your terminal:

´´´sh
$ gem install claiss
´´´

## Usage

### Version

To check the CLAISS version:

´´´sh
$ claiss version
´´´

or use the shortcuts:

´´´sh
$ claiss v
$ claiss -v
$ claiss --version
´´´

### Refactor

The `refactor` command allows you to rename and replace text terms within files and filenames in a specified directory. This command will refactor all exact occurrences of specified terms, including filenames.

**Note:** The `refactor` command ignores the `.git/` and `node_modules/` directories to avoid modifying critical or third-party files.

Basic usage:

´´´sh
$ claiss refactor <project_path> <json_file>
´´´

Example:

´´´sh
$ claiss refactor llama_index laiss_labs.json
´´´

#### Using a JSON Dictionary

You can create a JSON file that specifies the terms you want to refactor. This JSON file should be structured as a simple key-value pair object, where each key is the term to be replaced and the value is the replacement term.

Example `laiss_labs.json`:

´´´json
{
    "system pro": "system b2b",
    "System Pro": "System B2b",
    "System": "Laiss",
    "system": "laiss"
}
´´´

**Important:** After refactoring, any empty directories left behind will be automatically removed to keep your project structure clean.

### Fix Ruby Permissions

The `fix_ruby_permissions` command adjusts file permissions for a Ruby or Rails project.

´´´sh
$ claiss fix_ruby_permissions <project_path>
´´´

## Future Features

We are continuously working to improve CLAISS and add new functionalities. Stay tuned for updates!

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/JulioPapel/claiss](https://github.com/JulioPapel/claiss).

## License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author

Júlio Papel

---

# Português

**CLAISS** é uma aplicação CLI e caixa de ferramentas em Ruby projetada para gerenciar aplicações e implantações CLAISS Refactored. Por favor, note que algumas funcionalidades podem ter compatibilidade limitada dependendo do ambiente. Use com cuidado!

## Instalação

Instale a gem CLAISS executando o seguinte comando no seu terminal:

´´´sh
$ gem install claiss
´´´

## Uso

### Versão

Para verificar a versão do CLAISS:

´´´sh
$ claiss version
´´´

ou use os atalhos:

´´´sh
$ claiss v
$ claiss -v
$ claiss --version
´´´

### Refactor

O comando `refactor` permite que você renomeie e substitua termos de texto dentro de arquivos e nomes de arquivos em um diretório especificado. Este comando irá refatorar todas as ocorrências exatas dos termos especificados, incluindo nomes de arquivos.

**Nota:** O comando `refactor` ignora os diretórios `.git/` e `node_modules/` para evitar modificar arquivos críticos ou de terceiros.

Uso básico:

´´´sh
$ claiss refactor <caminho_do_projeto> <arquivo_json>
´´´

Exemplo:

´´´sh
$ claiss refactor llama_index laiss_labs.json
´´´

#### Usando um Dicionário JSON

Você pode criar um arquivo JSON que especifica os termos que deseja refatorar. Este arquivo JSON deve ser estruturado como um objeto de pares chave-valor simples, onde cada chave é o termo a ser substituído e o valor é o termo de substituição.

Exemplo `laiss_labs.json`:

´´´json
{
    "system pro": "system b2b",
    "System Pro": "System B2b",
    "System": "Laiss",
    "system": "laiss"
}
´´´

**Importante:** Após a refatoração, quaisquer diretórios vazios deixados para trás serão automaticamente removidos para manter a estrutura do seu projeto limpa.

### Fix Ruby Permissions

O comando `fix_ruby_permissions` ajusta as permissões de arquivos para um projeto Ruby ou Rails.

´´´sh
$ claiss fix_ruby_permissions <caminho_do_projeto>
´´´

## Recursos Futuros

Estamos continuamente trabalhando para melhorar o CLAISS e adicionar novas funcionalidades. Fique atento para atualizações!

## Contribuindo

Relatórios de bugs e pull requests são bem-vindos no GitHub em [https://github.com/JulioPapel/claiss](https://github.com/JulioPapel/claiss).

## Licença

Esta gem está disponível como código aberto sob os termos da [Licença MIT](https://opensource.org/licenses/MIT).

## Autor

Júlio Papel