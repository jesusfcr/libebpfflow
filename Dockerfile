FROM ubuntu:18.04 as builder
RUN apt-get update && apt-get install -y build-essential autoconf automake autogen libjson-c-dev pkg-config libzmq3-dev libcurl4-openssl-dev libbpfcc-dev
WORKDIR /app
COPY . .
RUN ./autogen.sh && make

FROM ubuntu:18.04

RUN echo "deb [trusted=yes] http://repo.iovisor.org/apt/bionic bionic-nightly main" | \
  tee /etc/apt/sources.list.d/iovisor.list && \
  apt-get update -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y bcc-tools

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libcurl4-openssl-dev libjson-c-dev libzmq3-dev libbpfcc-dev

COPY --from=builder /app/ebpflowexport /usr/share/

ENTRYPOINT ["/usr/share/ebpflowexport"]
