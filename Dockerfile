FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04
MAINTAINER Hu Yao <hooyao@gmail.com>

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ENV CONDA_ENV_NAME=tf-180-gpu-36
ENV TF_FILE_NAME=tensorflow_gpu-1.8.0-cp36-cp36m-linux_x86_64.whl

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update --fix-missing && apt-get install -y bzip2 curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl  https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh --output miniconda.sh \
    && chmod +wrx miniconda.sh \
    && sh miniconda.sh -b \
    && rm miniconda.sh
ENV OLD_PATH=$PATH
ENV PATH=/root/miniconda2/bin:$PATH
#RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
RUN conda config --set show_channel_urls yes

RUN conda create -n ${CONDA_ENV_NAME} python=3.6 -y
RUN curl https://storage.googleapis.com/tensorflow/linux/gpu/${TF_FILE_NAME} --output ${TF_FILE_NAME} \
    && chmod +wrx ${TF_FILE_NAME} \
    && source activate ${CONDA_ENV_NAME} && pip install --ignore-installed --upgrade ${TF_FILE_NAME} \
    && source activate ${CONDA_ENV_NAME} && conda install pandas scikit-learn scipy matplotlib sympy -y \
    && source activate ${CONDA_ENV_NAME} && conda install jupyter nb_conda -y \
    && conda clean -a \
    && rm ${TF_FILE_NAME}
ENV PATH=/root/miniconda2/envs/${CONDA_ENV_NAME}/bin/:$OLD_PATH

RUN mkdir /root/pyprojects
WORKDIR /root/pyprojects
VOLUME /root/pyprojects

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

