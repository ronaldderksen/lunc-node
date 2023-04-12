FROM lunc-node-base

RUN mkdir -p /var/spool/cron/crontabs
RUN ln -s busybox /usr/sbin/crond
RUN ln -s busybox /usr/sbin/crontab

USER terra

ENV HOME=/home/terra

RUN pip3 install terra-sdk
RUN sed -i 's/pisco-1/columbus-5/g' $HOME/.local/lib/*/site-packages/terra_sdk/client/lcd/lcdclient.py
ENV PATH=$HOME/go/bin:$HOME/.local/bin:$PATH

COPY monitor.py /bin/monitor.py
COPY ntfy.py /bin/ntfy.py
COPY config.yaml /usr/local/etc/config.yaml

USER root

COPY crontab /var/spool/cron/crontabs/terra
COPY entrypoint.sh /bin/entrypoint.sh
COPY start.sh /bin/start.sh

RUN chmod 755 /bin/entrypoint.sh /bin/start.sh /bin/ntfy.py /bin/monitor.py
ENTRYPOINT ["/bin/entrypoint.sh"]

CMD ["crond", "-f", "-l1"]
