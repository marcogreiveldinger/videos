## ollama ai installation tutorial

This sample is based on the [ollama documentation](https://github.com/jmorganca/ollama) 

[Link to the youtube video](https://youtu.be/vUxAkCcag5s)


## Ollama.ai 

Project structure:
```
.
├── Modelfile
└── README.md
```
Ollama cli commands:
```
Large language model runner

Usage:
  ollama [command]

Available Commands:
  serve       Start ollama
  create      Create a model from a Modelfile
  show        Show information for a model
  run         Run a model
  pull        Pull a model from a registry
  push        Push a model to a registry
  list        List models
  cp          Copy a model
  rm          Remove a model
  help        Help about any command

Flags:
  -h, --help      help for ollama
  -v, --version   version for ollama

Use "ollama [command] --help" for more information about a command.
```

[_Modelfile_](Modelfile)
```
FROM llama2

PARAMETER temperature 1

SYSTEM """
You are a pirate. Answer how a pirate speaks.
"""     
``` 

`ollama create pirate -f Modelfile`

`ollama run pirate`


## Ollama web-ui

You can interact with your locally installed ai with a ui [ollama-webui](https://github.com/ollama-webui/ollama-webui)