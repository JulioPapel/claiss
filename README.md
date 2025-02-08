# CLAISS CLI Refactor Application Toolbox

[English](#english) | [Português](#português)

# English

**CLAISS** is a Ruby-based CLI application and toolbox designed to manage CLAISS Refactored applications and deployments. It provides powerful refactoring capabilities with improved performance and safety features. Please note that some features may have limited compatibility depending on the environment. Use with caution!

## Installation

Install the CLAISS gem by running the following command in your terminal:

```sh
$ gem install claiss
```

## Usage

### Version

To check the CLAISS version:

```sh
$ claiss version
```

or use the shortcuts:

```sh
$ claiss v
$ claiss -v
$ claiss --version
```

### Refactor

The `refactor` command allows you to rename and replace text terms within files and filenames in a specified directory. This command will refactor all exact occurrences of specified terms, including filenames.

**Note:** The `refactor` command ignores the `.git/` and `node_modules/` directories to avoid modifying critical or third-party files.

Basic usage:

```sh
$ claiss refactor ./project/ ./my_changes.json
```

#### Using a JSON Dictionary

You can create a JSON file that specifies the terms you want to refactor. This JSON file should be structured as a simple key-value pair object, where each key is the term to be replaced and the value is the replacement term.

Example `my_changes.json`:

```json
{
    "system pro": "system b2b",
    "System Pro": "System B2b",
    "System": "Laiss",
    "system": "laiss",
    "2010 Moevo Silver": "2023 Júlio Papel",
    "Jared Moevo": "Júlio Papel",
    "3dtester@gmail.com": "info@mynewsite.pt",
    "https://somelivesite.com": "https://api.mynewsite.pt",
    "This is your Rails project.": "Multi Layered Software Services.",
    "This is your Rails project for your business.": "A Multi Layered Software Services ready to be deployed for any business.",
    "MIT-LICENSE": "LICENSE",
    "https://somesite.com": "https://api.mynewsite.pt"
}
```

To apply the changes using the dictionary file:

```sh
$ claiss refactor ./project/ ./my_changes.json
```

**Important:** After refactoring, any empty directories left behind will be automatically removed to keep your project structure clean.

### Fix Ruby Permissions

The `fix_ruby_permissions` command adjusts file permissions for a Ruby or Rails project.

```sh
$ claiss fix_ruby_permissions ./project/
```

**Note:** This command uses `chmod` and may encounter issues on systems that do not distinguish between uppercase and lowercase filenames or support spaces in filenames (e.g., certain end-user operating systems). If you encounter errors, particularly with filenames like `MyImage copy.svg`, manually fix those file permissions and re-run the command.

## Upcoming Features

We are continuously working to improve CLAISS and add new functionalities. Some planned features include:

1. Enhanced error handling and reporting
2. Support for more complex refactoring rules

Stay tuned for updates!

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/JulioPapel/claiss](https://github.com/JulioPapel/claiss).

## License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author

Júlio Papel
