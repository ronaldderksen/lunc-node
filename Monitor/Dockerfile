ARG GIT_TAG
ARG IMAGE_PREFIX
FROM ${IMAGE_PREFIX}lunc-node-base:$GIT_TAG

USER terra

ENV HOME=/home/terra

RUN pip3 install terra-sdk && \
    sed -i 's/pisco-1/columbus-5/g' $HOME/.local/lib/*/site-packages/terra_sdk/client/lcd/lcdclient.py && \
    mkdir -p $HOME/.bashrc.d && echo 'PATH=$HOME/go/bin:$HOME/.local/bin:$PATH' >$HOME/.bashrc.d/path
ENV PATH=$HOME/go/bin:$HOME/.local/bin:$PATH

COPY monitor.py /bin/monitor.py
COPY ntfy.py /bin/ntfy.py
COPY config.yaml /usr/local/etc/config.yaml

USER root

RUN mkdir -p /var/spool/cron/crontabs && \
    ln -s busybox /usr/sbin/crond && \
    ln -s busybox /usr/sbin/crontab

COPY crontab /var/spool/cron/crontabs/terra
COPY entrypoint.sh /bin/entrypoint.sh
COPY start.sh /bin/start.sh

RUN chmod 755 /bin/entrypoint.sh /bin/start.sh /bin/ntfy.py /bin/monitor.py
ENTRYPOINT ["/bin/entrypoint.sh"]

CMD ["crond", "-f", "-l1"]
