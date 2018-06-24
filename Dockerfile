FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04
LABEL author="Hu Yao <hooyao@gmail.com>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
#ENV CONDA_BIN=https://repo.continuum.io/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh
ENV CONDA_BIN=https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh
ENV TF_FILE_NAME=tensorflow_gpu-1.8.0-cp36-cp36m-linux_x86_64.whl

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

RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/ && \
    conda config --set show_channel_urls yes

RUN conda install -y python=3.6 && \
    conda update conda && \
    conda install numpy pandas scikit-learn scipy matplotlib sympy jupyter nb_conda -y &&\
    conda clean -a && \
    rm -rf /opt/conda/pkgs/*
RUN curl https://storage.googleapis.com/tensorflow/linux/gpu/${TF_FILE_NAME} --output ${TF_FILE_NAME} && \
    chmod +wrx ${TF_FILE_NAME} && \
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple ${TF_FILE_NAME} && \
    rm ${TF_FILE_NAME} && \
    rm -rf /root/.cache/pip/*

RUN mkdir /root/pyprojects
WORKDIR /root/pyprojects
VOLUME /root/pyprojects

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

