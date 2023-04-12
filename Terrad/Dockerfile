FROM lunc-node-base

USER terra

ENV HOME=/home/terra

RUN pip3 install toml-cli

RUN mkdir $HOME/git && cd $HOME/git && git clone https://github.com/classic-terra/core/ && cd core && git checkout v1.1.0 && make install

ENV PATH=$HOME/go/bin:$HOME/.local/bin:$HOME/lunc-node/bin:$PATH

RUN ln -s /terra $HOME/.terra

ARG P2P_PORT
ARG API_PORT

EXPOSE $P2P_PORT
EXPOSE $API_PORT

COPY --chown=terra gas.py /bin/gas.py
COPY --chown=terra entrypoint.sh /bin/entrypoint.sh
RUN chmod 755 /bin/entrypoint.sh /bin/gas.py
ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["terrad","start"]
