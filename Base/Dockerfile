FROM rockylinux:9

ARG GIT_TAG
ARG TERRA_UID
ARG TERRA_GID

RUN echo GIT_TAG=$GIT_TAG && \
    dnf -y install epel-release && \
    dnf -y module enable nodejs:18 && \
    dnf -y install golang git lz4 jq procps-ng python3-pip python3-requests python3-pyyaml vim-enhanced npm sudo busybox && \
    groupadd -g $TERRA_GID terra && useradd --create-home -g $TERRA_GID -u $TERRA_UID terra

COPY sudoers-terra /etc/sudoers.d/sudoers-terra

RUN ["bash"]
