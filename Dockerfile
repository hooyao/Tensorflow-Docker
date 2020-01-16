FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04

LABEL author="Hu Yao <hooyao@gmail.com>"

ARG CONDA_BIN=https://repo.anaconda.com/miniconda/Miniconda2-4.7.12.1-Linux-x86_64.sh

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

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
    conda install numpy pandas cython scikit-learn scipy matplotlib sympy jupyter nb_conda -y && \
    conda clean -a && \
    rm -rf /opt/conda/pkgs/*

RUN pip install --upgrade --upgrade-strategy only-if-needed tensorflow-gpu==2.1.0 && \
    rm -rf /root/.cache/pip/*

RUN mkdir /root/pyprojects
WORKDIR /root/pyprojects
VOLUME /root/pyprojects

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

