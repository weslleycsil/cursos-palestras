FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    liblzma-dev \
    gcc \
    make \
    && rm -rf /var/lib/apt/lists/*

COPY ./scripts/compilar.sh /opt/src/scripts/compilar.sh

#CMD /opt/src/scripts/compilar.sh
RUN chmod +x /opt/src/scripts/compilar.sh

ENTRYPOINT ["/opt/src/scripts/compilar.sh"]

#ENTRYPOINT [ "/bin/bash" ]

VOLUME [ "/opt/src/binarios" ]
