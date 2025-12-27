#!/bin/sh

JOBS=$(nproc)

# Download sources
cd srctars

wget https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.18.2.tar.xz
wget https://busybox.net/downloads/busybox-1.36.1.tar.bz2

cd ..

# Extract sources
tar -xvf srctars/linux-6.18.2.tar.xz
tar -xvf srctars/busybox-1.36.1.tar.bz2

# BusyBox setup
cd busybox-1.36.1

make distclean
make defconfig

# Build BusyBox static (important for initramfs)
sed -i 's/^# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config

make -j"$JOBS"

rm -rf ./_rootfs
mkdir -p ./_rootfs
make CONFIG_PREFIX="$PWD/_rootfs" install

cd ..

# Initramfs setup
rm -rf initramfs/initramfsroot/*
cp -a busybox-1.36.1/_rootfs/* initramfs/initramfsroot/

cd initramfs/initramfsroot
mkdir -p proc sys dev etc tmp root lib

cat > init <<'EOF'
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev 2>/dev/null || echo "no devtmpfs"

echo "Booted. Kernel: $(uname -a)"
echo "Mounts:"
cat /proc/mounts

exec /bin/sh
EOF

chmod +x init

cd ..
./packinitramfs.sh
cd ..

# Linux kernel setup
cd linux-6.18.2

make mrproper
make defconfig
make -j"$JOBS"

cd ..

