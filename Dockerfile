#FROM jupyter/base-notebook:033056e6d164
FROM ubuntu:zesty

USER root

# install debian packages
RUN apt-get update && apt-get install -y --no-install-recommends \
            build-essential      \
            python-setuptools    \
            python-wheel         \
            python-pip           \
            python-dev           \
            postgresql           \
            less                 \
            nano                 \
            sudo                 \
            wget                 \
            ca-certificates      \
  && rm -rf /var/lib/apt/lists/*

# install Python packages
COPY requirements.txt /opt/
RUN pip2 install --no-cache-dir -r /opt/requirements.txt

# active ipython kernels
RUN python2 -m ipykernel install

# enable Jupyter extensions
RUN jupyter nbextension     enable  --sys-prefix --py widgetsnbextension   && \
    jupyter nbextension     enable  --sys-prefix --py nglview              && \
    jupyter nbextension     enable  --sys-prefix --py bqplot               && \
    jupyter nbextension     enable  --sys-prefix --py appmode              && \
    jupyter serverextension enable  --sys-prefix --py appmode

# create ubuntu user with sudo powers
RUN adduser --disabled-password --gecos "" ubuntu               && \
    echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >>  /etc/sudoers
USER ubuntu

# configure AiiDA
WORKDIR /home/ubuntu/
COPY configure_aiida.sh ./
RUN ./configure_aiida.sh

# download notebooks
RUN mkdir /home/ubuntu/apps
WORKDIR /home/ubuntu/apps
RUN wget https://github.com/cpignedoli/mc-empa-surfaces/archive/v0.0.1.tar.gz && \
    tar -xvzf v0.0.1.tar.gz                                                    && \
    rm v0.0.1.tar.gz                                                          && \
    mv mc-empa-surfaces-0.0.1 surfaces

RUN wget https://github.com/materialscloud-org/mc-aiida/archive/v0.0.1.tar.gz && \
    tar -xvzf v0.0.1.tar.gz                                                    && \
    rm v0.0.1.tar.gz                                                          && \
    mv mc-aiida-0.0.1 aiida

WORKDIR /home/ubuntu/
COPY start_demo.ipynb ./

# Launch Notebook server (will be ignored by binder)
WORKDIR /home/ubuntu/
EXPOSE 8888
CMD ["jupyter-notebook", "--ip=0.0.0.0", "--no-browser", "--NotebookApp.token=''"]

# EOF