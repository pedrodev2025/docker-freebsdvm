#!/bin/bash

ISO_PATH="/data/freebsd.iso"
DISK_PATH="/data/freebsd.qcow2"

TOTAL_RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')

HALF_RAM_MB=$(($TOTAL_RAM_KB / 2 / 1024))

echo "Total de RAM do sistema: $(($TOTAL_RAM_KB / 1024)) MB"
echo "Usando $HALF_RAM_MB MB para a VM FreeBSD."

mkdir -p /data

if [ ! -f "$ISO_PATH" ]; then
    echo "Baixando a imagem ISO do FreeBSD..."
    wget https://download.freebsd.org/releases/amd64/amd64/ISO-IMAGES/14.3/FreeBSD-14.3-RELEASE-amd64-disc1.iso -O "$ISO_PATH"
fi

if [ ! -f "$DISK_PATH" ]; then
    echo "Criando o disco virtual para a VM..."
    qemu-img create -f qcow2 "$DISK_PATH" 256G
fi

qemu-system-x86_64 \
    -enable-kvm \
    -m ${HALF_RAM_MB}M \
    -cpu host \
    -smp 2 \
    -hda "$DISK_PATH" \
    -cdrom "$ISO_PATH" \
    -vga virtio \
    -display gtk \
    -netdev user,id=vlan0 \
    -device virtio-net-pci,netdev=vlan0
