FROM lunc-node-base

USER terra

ENV HOME=/home/terra
ENV NODE_OPTIONS=--openssl-legacy-provider

RUN mkdir -p $HOME/git && \
    cd $HOME/git && git clone https://github.com/classic-terra/oracle-feeder.git && \
    cd $HOME/git/oracle-feeder/feeder && \
    sed -i 's/args.validators/args.validator/' src/index.ts && \
    npm install && \
    ln -s /terra/voter.json voter.json

COPY --chown=terra entrypoint.sh /bin/entrypoint.sh
COPY --chown=terra start.sh /bin/start.sh
RUN chmod 755 /bin/entrypoint.sh /bin/start.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["/bin/start.sh"]