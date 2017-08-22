FROM ubuntu:16.04
MAINTAINER Hu Yao <hooyao@gmail.com>

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ENV CONDA_ENV_NAME=tf-cpu-36
ENV TF_FILE_NAME=tensorflow-1.3.0-cp36-cp36m-linux_x86_64.whl

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update --fix-missing && apt-get install -y bzip2
ADD https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh miniconda.sh
RUN chmod +wrx miniconda.sh
RUN sh miniconda.sh -b
RUN rm miniconda.sh
ENV OLD_PATH=$PATH
ENV PATH=/root/miniconda2/bin:$PATH
RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
RUN conda config --set show_channel_urls yes
RUN rm -f Miniconda2-latest-Linux-x86_64.sh

RUN conda create -n ${CONDA_ENV_NAME} python=3.6 -y
ADD https://storage.googleapis.com/tensorflow/linux/cpu/${TF_FILE_NAME} ${TF_FILE_NAME}
RUN chmod +wrx ${TF_FILE_NAME}
RUN source activate ${CONDA_ENV_NAME} && pip install --ignore-installed --upgrade ${TF_FILE_NAME}
RUN source activate ${CONDA_ENV_NAME} && conda install pandas scikit-learn scipy matplotlib sympy -y
RUN source activate ${CONDA_ENV_NAME} && conda install jupyter nb_conda -y
RUN rm ${TF_FILE_NAME}
ENV PATH=/root/miniconda2/envs/${CONDA_ENV_NAME}/bin/:$OLD_PATH

RUN mkdir /root/pyprojects
WORKDIR /root/pyprojects
VOLUME /root/pyprojects

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

