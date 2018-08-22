FROM ubuntu:18.04

RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Europe/Vienna /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get install -y build-essential libssl-dev curl nodejs npm python python-pip python-dev pandoc texlive-xetex
RUN pip install --upgrade pip==9.0.3
RUN pip install jupyter
WORKDIR /root
RUN npm --unsafe-perm install -g ijavascript && ijsinstall

WORKDIR /root
RUN adduser --disabled-password --gecos "" jupyter
RUN jupyter notebook --generate-config && \
    echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.password = u'sha1:37c14f4a2b90:0742999935c4297b7016ae0c31e2b16c3d919d52'" >> /root/.jupyter/jupyter_notebook_config.py
RUN mkdir -p /opt/work
RUN chown -R jupyter:jupyter /opt/work
WORKDIR /opt/work
EXPOSE 8888
ENTRYPOINT ["ijs", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--notebook-dir=/opt/work" ]
