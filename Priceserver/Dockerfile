FROM lunc-node-base

USER terra

ENV HOME=/home/terra
ENV NODE_OPTIONS=--openssl-legacy-provider

RUN mkdir -p $HOME/git && \
    cd $HOME/git && git clone https://github.com/ronaldderksen/oracle-feeder.git && cd oracle-feeder/price-server && \
    git checkout old-lunc-price-server && \
    npm install

COPY price-server/default.js $HOME/git/oracle-feeder/price-server/config/default.js

EXPOSE 8532

COPY --chown=terra entrypoint.sh /bin/entrypoint.sh
COPY --chown=terra start.sh /bin/start.sh
RUN chmod 755 /bin/entrypoint.sh /bin/start.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["/bin/start.sh"]
