# Laiss AI CLI application Toolbox
Claiss is a Ruby CLI application & Toolbox to manage Laiss AI applications and deployments. Some thing may not work on your environment. Use with caution!

## Installation:

```
$ gem install claiss
```

add a refactor.claiss file anywere outside your project. The content shuld be formatted as follows:

```json
{
  "system pro" : "laiss b2b",
  "System Pro" : "Laissb2b",
  "System" : "Laiss",
  "system" : "laiss",
  "2018 Moevo Silver" : "2023 Júlio Papel",
  "Jason Moevo" : "Júlio Papel",
  "3drefxtester@gmail.com" : "info@mynewsite.pt",
  "https://somelivesite.com" : "https://api.mynewsite.pt",
  "This is your Rails project." : "Multi Layered Software Services.",
  "This is your Rails project for your business." : "A Multi Layered Software Services ready to be deployed for any business.",
  "MIT-LICENSE" : "LICENSE",
  "https://somesite.com" : "https://api.mynewsite.pt"

}
``` 

## Usage:

```
claiss refactor path/project/ refactor.claiss
```
Or to be asked for the terms:
```
claiss refactor path/project/ 
```

Other fuctionalities will come soon.
Cheers!
Júlio Papel
