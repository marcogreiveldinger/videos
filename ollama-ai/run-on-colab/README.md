## ollama ai on google colab

This sample is based on the [ollama documentation](https://github.com/jmorganca/ollama/tree/5687f1a0cfa3d2408bfcb04f4342f657f6dada58/examples/jupyter-notebook) 

[Link to the youtube video](https://youtu.be/Qa1h7ygwQq8)

[Google Colab](https://colab.google)

[Jupyter notebook](./ollama-ai-colab.ipynb)

## Ollama.ai & Google Colab

This directory contains a jupyter notebook that installs ollama.ai on google colab and runs a model.
It helps you to run large language models on google colab without the need to have a powerful machine at your home.
Make sure that you have a T4 instance selected in the google colab settings so you can make use of the GPU.

Create an account at https://ngrok.com/ and create an authtoken for your jupyter-notebook. Place it in the line where the autthoken is added to the ngrok conf.

Project structure:
```
.
├── ollama-ai-colab.ipynb
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
