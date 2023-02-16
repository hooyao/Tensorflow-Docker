FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04
LABEL author="Hu Yao <hooyao@gmail.com>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
#tensorrt 7 only supports python 3.8
ENV CONDA_BIN=https://repo.anaconda.com/miniconda/Miniconda3-py38_23.1.0-1-Linux-x86_64.sh 

RUN apt-get -qq update && apt-get -qq -y install curl bzip2 \
    && curl -sSL ${CONDA_BIN} -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /opt/conda/ \
    && rm -rf /tmp/miniconda.sh \
    && apt-get -qq -y remove bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && export PATH=/opt/conda/bin:$PATH \
    && conda clean --all --yes
ENV PATH /opt/conda/bin:$PATH

ARG PIP_CACHE="--index-url http://192.168.1.15:9192/index --trusted-host 192.168.1.15 --timeout=30"
#ARG PIP_CACHE="--extra-index-url https://pypi.ngc.nvidia.com"
RUN pip install --upgrade pip \
    && pip install ${PIP_CACHE} nvidia-cuda-runtime==11.3.58 nvidia-tensorrt==7.2.3.4 tensorflow==2.11.0 --debug \
    && rm -rf /root/.cache/pip/*
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/conda/lib/python3.8/site-packages/tensorrt
ENV MKL_DEBUG_CPU_TYPE=5

 RUN conda install numpy pandas cython scikit-learn scipy matplotlib -y \ 
    && conda install -c conda-forge jupyterlab \
    && conda clean -a \
    && rm -rf /opt/conda/pkgs/*

 RUN mkdir /root/pyprojects
 WORKDIR /root/pyprojects
 VOLUME /root/pyprojects
 # TensorBoard
 EXPOSE 6006
 # IPython
 EXPOSE 8888

