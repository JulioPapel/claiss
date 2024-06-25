# CLAISS AI CLI Application Toolbox

CLAISS is a Ruby CLI application & Toolbox to manage CLAISS AI applications and deployments. Please note that some features may not work in all environments. Use with caution!

## Installation

Install the gem by running the following command in your terminal:

Copy

`$ gem install claiss`

## Usage

### Refactor

The `refactor` command changes text terms in files within a folder, creating a new "refactored-..." folder with the modified files. Note that this command will change all exact occurrences of the specified terms. For example, "Abc" is treated differently from "Abc " or " Abc" or "abc".

Basic usage:

Copy

`$ claiss refactor ./project/`

#### Using a JSON Dictionary

You can create a JSON file with a list of terms to refactor. This file should be formatted as a one-level JSON object. The terms are processed in order from top to bottom.

Example `myapp.json` file:

Copy

`{  "system pro": "system b2b", "System Pro": "System B2b", "System": "Laiss", "system": "laiss", "2010 Moevo Silver": "2023 Júlio Papel", "Jared Moevo": "Júlio Papel", "3dtester@gmail.com": "info@mynewsite.pt", "https://somelivesite.com": "https://api.mynewsite.pt", "This is your Rails project.": "Multi Layered Software Services.", "This is your Rails project for your business.": "A Multi Layered Software Services ready to be deployed for any business.", "MIT-LICENSE": "LICENSE", "https://somesite.com": "https://api.mynewsite.pt" }`

To use this dictionary file:

Copy

`$ claiss refactor ./project/ ./myapp.json`

### Fix Ruby Permissions

The `fix_ruby_permissions` command adjusts file permissions for a Ruby & Rails project:

Copy

`$ claiss fix_ruby_permissions ./refactored-1688375056/`

**Note:** This command uses `chmod` and may not work correctly on systems that support filename spaces and ignore capitals (like some end-user operating systems). For example, a file called 'MyImage copy.svg' may cause errors. In such cases, manually fix the permissions for problematic files and then re-run the command.

## Upcoming Features

We're continually working to improve CLAISS and add new functionalities. Stay tuned for updates!

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/JulioPapel/claiss](https://github.com/JulioPapel/claiss).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author

Júlio Papel