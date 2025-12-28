#!/bin/sh

qemu-system-x86_64 \
  -kernel linux-6.18.2/arch/x86/boot/bzImage \
  -initrd initramfs/initramfs.cpio.gz \
  -append "console=ttyS0 rdinit=/init" \
  -nographic

