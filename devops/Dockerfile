FROM continuumio/miniconda3
LABEL maintainer="https://github.ibm.com/GTS-CDO/unstructured-analytics"

RUN echo "9.209.225.220	wftag" >> /etc/hosts

# The DB2 download is unrelaible: do not remove the --quiet flag
WORKDIR /home/db2_cli_odbc_driver
RUN apt-get update && \
    apt-get --assume-yes install \
       build-essential \
       iputils-tracepath \
       wget && \
    wget https://public.dhe.ibm.com/ibmdl/export/pub/software/data/db2/drivers/odbc_cli/linuxx64_odbc_cli.tar.gz -O odbc_cli.tar.gz && \
    tar -xvf odbc_cli.tar.gz && rm odbc_cli.tar.gz && \
    echo /home/db2_cli_odbc_driver/clidriver/lib > /etc/ld.so.conf.d/db2.conf && \
    ldconfig && \
    conda config --set always_yes yes && \
    conda update -q conda && \
    apt-get purge -y --auto-remove wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PYTHONUNBUFFERED=1 \
    IBM_DB_HOME=/home/db2_cli_odbc_driver/clidriver
VOLUME /home/db2_cli_odbc_driver/clidriver/license-secret

# Try to inimize the layers that are rebuilt
# and the amount of work involved in each step:
# - `environment.yml` does not change in every commit
#   and it triggers very expensive steps.
# - `setup` needs to be copied to a different folder,
#   or the cache gets invalidated
WORKDIR /code
COPY ./setup /setup
COPY environment.yml /code
RUN conda env create -f=environment.yml
RUN /bin/bash -c "echo 'Setting up spacy...' && \
    source /opt/conda/etc/profile.d/conda.sh && \
    conda activate gtstext && \
    /setup/spacy.sh"
ENTRYPOINT [ "/bin/bash" , "-c" ]
CMD [ "/code/devops/jenkins/run-in-jenkins-docker.sh" ]
COPY . /code
