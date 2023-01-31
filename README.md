# fmiSWAP

This repository contains a watertank with model swap and a `Dockerfile` to build a running example using the Maestro co-orchestration engine for FMI-based co-simulation with the model swap feature including a FaultInject extension.

# Getting started - Quick setup

In order to quickly run the experiment and produce the results of the artefact paper ("Dynamic Runtime Integration of New Models in Digital Twins" [H. Ejersbo, K. Lausdahl, M. Frasheri, L. Esterle]) do the following:

## Clone this repo

Clone this repo locally

```bash
$ git clone https://github.com/lausdahl/SEAMS2023Artefact-fmiSWAP.git
```

Change to the repo directory before going to the next step.

## Build the image

```bash
$ docker build . --tag lausdahl/maestro:2.3.0-model-swap
```

## Run the example

```bash
$ docker run -it -v ${PWD}:/work/model/post  lausdahl/maestro:2.3.0-model-swap
```

After this step completes, you should see in the containing folder two files ```result.png``` and ```result.pdf```, showing the plot included in the paper. 

# Details of usage

For futher information about the image content see the `README_dockerhub.md`.