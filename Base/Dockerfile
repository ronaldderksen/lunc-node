FROM rockylinux:9

RUN dnf -y install epel-release && \
    dnf -y module enable nodejs:18 && \
    dnf -y install golang git lz4 jq procps-ng python3-pip python3-requests python3-pyyaml vim-enhanced npm sudo busybox && \
    groupadd -g 1002 terra && useradd --create-home -g 1002 -u 1002 terra

COPY sudoers-terra /etc/sudoers.d/sudoers-terra

RUN ["bash"]
