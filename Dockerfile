FROM ubuntu:24.04
RUN apt-get update && apt-get install -y \
    qemu-kvm \
    qemu-utils \
    wget \
    ca-certificates \
    qemu-system-gui \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /data
COPY start.sh .
RUN chmod +x ./start.sh
ENTRYPOINT ["./start.sh"]
