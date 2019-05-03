FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu16.04
LABEL author="Hu Yao <hooyao@gmail.com>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV CONDA_BIN=https://repo.continuum.io/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh
ENV TF_FILE_NAME=tensorflow_gpu-1.13.1-cp37-cp37m-linux_x86_64.whl

RUN apt-get -qq update && apt-get -qq -y install curl bzip2 \
    && curl -sSL ${CONDA_BIN} -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && apt-get -qq -y remove bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes
ENV PATH /opt/conda/bin:$PATH

RUN conda install -y python=3.7 && \
    conda update conda && \
    conda install numpy pandas cython scikit-learn scipy matplotlib sympy jupyter nb_conda -y &&\
    conda clean -a && \
    rm -rf /opt/conda/pkgs/*
RUN curl https://storage.googleapis.com/tensorflow/linux/gpu/${TF_FILE_NAME} --output ${TF_FILE_NAME} && \
    chmod +wrx ${TF_FILE_NAME} && \
    pip install ${TF_FILE_NAME} && \
    rm ${TF_FILE_NAME} && \
    rm -rf /root/.cache/pip/*

RUN mkdir /root/pyprojects
WORKDIR /root/pyprojects
VOLUME /root/pyprojects

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

