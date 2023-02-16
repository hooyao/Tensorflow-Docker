#FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04
LABEL author="Hu Yao <hooyao@gmail.com>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
#tensorrt 7 only supports python 3.8
ENV CONDA_BIN=https://repo.anaconda.com/miniconda/Miniconda3-py38_23.1.0-1-Linux-x86_64.sh 
#ENV CONDA_BIN=https://repo.anaconda.com/miniconda/Miniconda3-py310_23.1.0-1-Linux-x86_64.sh

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

RUN pip install --upgrade pip \
    && pip install  --index-url http://10.172.204.155:9191/index --trusted-host 10.172.204.155 nvidia-cuda-runtime==11.3.58 \
    && pip install  --index-url http://10.172.204.155:9191/index --trusted-host 10.172.204.155 nvidia-tensorrt==7.2.3.4 \
    && pip install  --index-url http://10.172.204.155:9191/index --trusted-host 10.172.204.155 tensorflow==2.11.0 \
    && rm -rf /root/.cache/pip/*
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/conda/lib/python3.8/site-packages/tensorrt
ENV MKL_DEBUG_CPU_TYPE=5

# RUN conda install numpy pandas cython scikit-learn scipy matplotlib sympy jupyter nb_conda -y &&\
#     conda clean -a && \
#     rm -rf /opt/conda/pkgs/*

# RUN pip install --upgrade --upgrade-strategy only-if-needed tensorflow-gpu==2.0.0 && \
#     rm -rf /root/.cache/pip/*

# RUN mkdir /root/pyprojects
# WORKDIR /root/pyprojects
# VOLUME /root/pyprojects

# # TensorBoard
# EXPOSE 6006
# # IPython
# EXPOSE 8888

