FROM rockylinux:9

RUN dnf -y install golang git lz4 jq procps-ng  python3-pip vim-enhanced

RUN groupadd -g 1002 terra && useradd --create-home -g 1002 -u 1002 terra

USER terra

ENV HOME=/home/terra

RUN pip3 install toml-cli

RUN mkdir $HOME/git && cd $HOME/git && git clone https://github.com/classic-terra/core/ && cd core && git checkout v1.1.0 && make install
RUN cd $HOME && git clone https://github.com/ronaldderksen/lunc-node.git

ENV PATH=$HOME/go/bin:$HOME/.local/bin:$HOME/lunc-node/bin:$PATH

RUN ln -s /terra $HOME/.terra

ARG P2P_PORT
ARG API_PORT

EXPOSE $P2P_PORT
EXPOSE $API_PORT

COPY --chown=terra entrypoint.sh /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
RUN chmod 755 /bin/entrypoint.sh
CMD ["terrad", "start"]
