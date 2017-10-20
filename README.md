How to use
---
GPU version
===
The GPU version only works on Linux, you need to setup Linux 
https://github.com/NVIDIA/nvidia-docker/wiki/Installation
then

```sh
nvidia-docker run -p 8888:8888 -p 6006:6006 --entrypoint=/bin/bash hooyao/tensorflow-dev:latestgpu -c 'source activate tf-gpu-36 && jupyter notebook --ip='*' --NotebookApp.token= --port=8888 --no-browser --allow-root'
```

CPU version
===
The cpu version runs everywhere

```sh
docker run -p 8888:8888 -p 6006:6006 --entrypoint=/bin/bash hooyao/tensorflow-dev:latestcpu -c 'source activate tf-cpu-36 && jupyter notebook --ip='*' --NotebookApp.token= --port=8888 --no-browser --allow-root'
```
