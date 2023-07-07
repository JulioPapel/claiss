# Laiss AI CLI application Toolbox
Claiss is a Ruby CLI application & Toolbox to manage Laiss AI applications and deployments. Some things may not work on your environment. Use with caution!

## Installation:
on your terminal type
```sh
$ gem install claiss
```

## Refactor:
Refactor changes text terms in files within a folder to another "refactored-..." folder. Keep in mind that this command will change all the exact occurrences of this term, for example "Abc" is different from "Abc " or " Abc" or "abc".

```sh
$ claiss refactor ./project/ 
```

You can create a json list of terms like ```myapp.dic``` file anywhere outside your project. This list is processed by order of precedence from top to bottom. The content should be formatted as a one level json hash, like:

```json
{
  "system pro" : "laiss b2b",
  "System Pro" : "Laissb2b",
  "System" : "Laiss",
  "system" : "laiss",
  "2010 Moevo Silver" : "2023 Júlio Papel",
  "Jared Moevo" : "Júlio Papel",
  "3drefxtester@gmail.com" : "info@mynewsite.pt",
  "https://somelivesite.com" : "https://api.mynewsite.pt",
  "This is your Rails project." : "Multi Layered Software Services.",
  "This is your Rails project for your business." : "A Multi Layered Software Services ready to be deployed for any business.",
  "MIT-LICENSE" : "LICENSE",
  "https://somesite.com" : "https://api.mynewsite.pt"

}
```
then you can call the list using:

```sh
$ claiss refactor ./project/ ./myapp.dic
```

## Fix Ruby Permissions:
Fix Ruby Permissions fixes permissions on a refactored Ruby & Rails project.
You can use it like this:
```sh
$ claiss fix_ruby_permissions ./refactored-1688375056/
```
  *note: Unix/Linux systems use diferent partitions for storing your files. This command usec CHMOD but may not work on systems that support filename spaces and ignore capitals, like on an end-user operating system. For example a file called 'MyImage copy.svg' will return 2 errors : No such file or directory.
  If this is your case then use chmod manually to fix those cases an then re-execute the command.



Other fuctionalities will come soon.
Cheers!
Júlio Papel
