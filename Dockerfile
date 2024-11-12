FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git sudo ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS prime
ARG TAGS
RUN echo "root:root" | chpasswd 
RUN addgroup --gid 1000 andrea
RUN adduser --gecos andrea --uid 1000 --gid 1000 --disabled-password andrea && adduser andrea sudo
RUN echo "andrea:andrea" | chpasswd
USER andrea
WORKDIR /home/andrea

FROM prime
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]

