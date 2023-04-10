FROM rockylinux:9

ARG P2P_PORT
ARG API_PORT

RUN dnf -y install golang git lz4 jq procps-ng  python3-pip vim-enhanced npm sudo

RUN groupadd -g 1002 terra && useradd --create-home -g 1002 -u 1002 terra

COPY sudoers-terra /etc/sudoers.d/sudoers-terra

USER terra

ENV HOME=/home/terra

RUN pip3 install toml-cli

RUN mkdir $HOME/git && cd $HOME/git && git clone https://github.com/classic-terra/core/ && cd core && git checkout v1.1.0 && make install
ENV NODE_OPTIONS=--openssl-legacy-provider
#RUN cd $HOME/git && git clone https://github.com/terra-rebels/oracle-feeder.git && cd oracle-feeder/price-server && \
RUN cd $HOME/git && git clone https://github.com/classic-terra/oracle-feeder.git && cd oracle-feeder/price-server && \
    npm install && \
    cd $HOME/git/oracle-feeder/feeder && \
    npm install && \
    ln -s /terra/voter.json voter.json

COPY price-server/default.js $HOME/git/oracle-feeder/price-server/config/default.js

#RUN cd $HOME && git clone https://github.com/ronaldderksen/lunc-node.git

ENV PATH=$HOME/go/bin:$HOME/.local/bin:$HOME/lunc-node/bin:$PATH

RUN ln -s /terra $HOME/.terra

EXPOSE $P2P_PORT
EXPOSE $API_PORT

COPY --chown=terra entrypoint.sh /bin/entrypoint.sh
COPY --chown=terra start.sh /bin/start.sh
RUN chmod 755 /bin/entrypoint.sh /bin/start.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["/bin/start.sh"]
