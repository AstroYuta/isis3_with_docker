FROM ubuntu:18.04
MAINTAINER AstroYuta
# SHELL ["/bin/bash", "-l", "-c"]

RUN apt-get update && apt-get install -y openssh-server x11-apps
RUN mkdir /run/sshd
RUN echo 'root:isis' | chpasswd
RUN sed -i 's/#\?PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN apt-get install -y xauth
RUN echo AddressFamily inet >> /etc/ssh/sshd_config
#COPY authorized_keys /root/.ssh/authorized_keys

# install conda and isis3
RUN apt-get install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 wget rsync emacs -y && \
    wget -P /opt https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh && \
    bash /opt/Anaconda3-2020.02-Linux-x86_64.sh -b -p /opt/anaconda3 && \
    rm /opt/Anaconda3-2020.02-Linux-x86_64.sh && \
    echo "export PATH=/opt/anaconda3/bin:$PATH" >> ~/.bashrc && \
    . ~/.bashrc && \
    conda init && \
    conda update -n base -c defaults conda

# install isis3
RUN . /opt/anaconda3/bin/activate && \
    conda create -n isis3 python=3.6 && \
    conda activate isis3 && \
    conda config --env --add channels conda-forge && \
    conda config --env --add channels usgs-astrogeology && \
    conda install -c usgs-astrogeology isis=3.10.0 && \
    python $CONDA_PREFIX/scripts/isis3VarInit.py --data-dir=/home/isis3/data  --test-dir=/home/isis3/testData

# download base data
RUN . /opt/anaconda3/bin/activate && \
    conda activate isis3 && \
    cd $ISIS3DATA && \
    rsync -azv --delete --partial isisdist.astrogeology.usgs.gov::isis3data/data/base . && \
    rsync -azv --delete --partial isisdist.astrogeology.usgs.gov::isis3data/data/hayabusa .
    
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]