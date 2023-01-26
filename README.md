# fmiSWAP

This repository contains a watertank with model swap and a `Dockerfile` to build a running example using Maestro with the model swap feature including a FaultInject extension.

For futher information about the image content see the `README_dockerhub.md`

# Build the image

```
docker build . --tag lausdahl/maestro:2.3.0-model-swap
```

to push the image use `docker login` and then `docker push lausdahl/maestro:2.3.0-model-swap`

# Run the example

```
docker run -it -v ${PWD}:/work/model/post  lausdahl/maestro:2.3.0-model-swap
```
