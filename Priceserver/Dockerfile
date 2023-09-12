ARG GIT_TAG
ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}lunc-node-base:$GIT_TAG

USER terra

ENV HOME=/home/terra
ENV NODE_OPTIONS=--openssl-legacy-provider

RUN mkdir -p $HOME/git && \
    cd $HOME/git && git clone https://github.com/classic-terra/oracle-feeder.git && cd oracle-feeder/price-server && \
    npm install

#RUN cp $HOME/git/oracle-feeder/price-server/config/default-sample.js $HOME/git/oracle-feeder/price-server/config/default.js
COPY price-server/default.js $HOME/git/oracle-feeder/price-server/config/default.js

EXPOSE 8532

COPY --chown=terra entrypoint.sh /bin/entrypoint.sh
COPY --chown=terra start.sh /bin/start.sh
RUN chmod 755 /bin/entrypoint.sh /bin/start.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["/bin/start.sh"]
