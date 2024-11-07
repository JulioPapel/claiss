# CLAISS CLI Refactor Application Toolbox

**CLAISS** is a Ruby-based CLI application and toolbox designed to manage CLAISS Refactored applications and deployments. It provides powerful refactoring capabilities with improved performance and safety features. Please note that some features may have limited compatibility depending on the environment. Use with caution!

## Installation

Install the CLAISS gem by running the following command in your terminal:

```sh
$ gem install claiss
```

## Usage

### Refactor

The `refactor` command allows you to rename and replace text terms within files and filenames in a specified directory. This command will refactor all exact occurrences of specified terms, including filenames. For example, "Abc" is treated differently from "AbC", "ABc", or "abc".

**Note:** The `refactor` command ignores the `.git/` and `node_modules/` directories to avoid modifying critical or third-party files.

Basic usage:

```sh
$ claiss refactor <path> <rules>
```

- `<path>`: Path to the directory to refactor (required)
- `<rules>`: Name of the rules file (without .json extension) (required)
- `--destination`: Destination path for refactored files (optional)

Examples:

```sh
$ claiss refactor path/to/project my_project
$ claiss refactor path/to/project my_project --destination path/to/output
```

#### Using a JSON Dictionary

You can create a JSON file that specifies the terms you want to refactor. This JSON file should be structured as a simple key-value pair object, where each key is the term to be replaced and the value is the replacement term. The terms are processed in the order they appear in the file.

The JSON file should be placed in the `~/.claiss/` directory by default.

Example `~/.claiss/my_project.json`:

```json
{
    "old_term": "new_term",
    "OldClassName": "NewClassName",
    "OLD_CONSTANT": "NEW_CONSTANT"
}
```

#### New Features and Improvements

1. **Progress Bar**: The refactoring process now displays a progress bar, giving you a visual indication of the operation's status.

2. **Parallel Processing**: Large projects are now processed using parallel execution, significantly improving performance on multi-core systems.

3. **Improved Encoding Handling**: The tool now better handles files with different encodings, falling back to binary reading for files with invalid UTF-8 sequences.

4. **Truncated Logging**: Log messages now show truncated file paths for improved readability, especially in projects with deep directory structures.

5. **Automatic Cleanup**: After refactoring, any empty directories left behind are automatically removed to keep your project structure clean.

### Fix Ruby Permissions

The `fix_ruby_permissions` command adjusts file permissions for a Ruby or Rails project. It ensures that directories have the correct execute permissions and that files retain their appropriate read/write/execute permissions.

```sh
$ claiss fix_ruby_permissions [path]
```

- `[path]`: Path to the Ruby project (optional, default: current directory)

Example:

```sh
$ claiss fix_ruby_permissions
$ claiss fix_ruby_permissions path/to/ruby/project
```

**Note:** This command uses `chmod` and may encounter issues on systems that do not distinguish between uppercase and lowercase filenames or support spaces in filenames (e.g., certain end-user operating systems). If you encounter errors, particularly with filenames like `MyImage copy.svg`, manually fix those file permissions and re-run the command.

### Generate JSON

The `generate_json` command helps create a new JSON file with an empty key-value pair for refactoring:

```sh
$ claiss generate_json [options]
```

Options:
- `--output`: Name of the output JSON file (default: rules)
- `--path`: Path to save the JSON file (default: ~/.claiss/)

Examples:

```sh
$ claiss generate_json
$ claiss generate_json --output my_custom_rules
$ claiss generate_json --path /custom/path/ --output my_rules
```

This command generates a new JSON file that can be used as a template for creating refactoring rules.

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