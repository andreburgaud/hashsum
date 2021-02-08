# Build stage
FROM debian:buster-slim as build

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends ca-certificates build-essential git libssl-dev libsqlite3-dev upx

WORKDIR /

# Build vlang
RUN git clone https://github.com/vlang/v.git

RUN cd v && \
    make && \
    ln -s /v/v /usr/bin/v

# Build hashsum tools
ADD . .

RUN cd / && \
    make clean && \
    make dist

FROM debian:buster-slim
ENV HASHSUM_HOME="/opt/hashsum"
RUN mkdir -p ${HASHSUM_HOME}/bin
COPY --from=build /dist/* /${HASHSUM_HOME}/bin/
ENV PATH="${HASHSUM_HOME}/bin:${PATH}"
WORKDIR /
CMD ["bash"]