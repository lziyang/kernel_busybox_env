rm -rf initramfsroot
mkdir initramfsroot
cd initramfsroot

zcat ../initramfs.cpio.gz | cpio -idmv

