#!/bin/bash

KERNEL_VERSION=$(make -f ../Makefile kernelversion)
INIT_NAME="init.sh"
INITRAMFS_DESC="initramfs_desc"

echo $KERNEL_VERSION

# prepare init
cat > ${INIT_NAME}<< EOF
#!/sbin/busybox sh

echo "INIT SCRIPT" 

echo "install busybox..." 
/sbin/busybox --install -s

insmod /lib/modules/${KERNEL_VERSION}/libcrc32c.ko 
insmod /lib/modules/${KERNEL_VERSION}/xfs.ko 

mount -t proc none /proc
mount -t devtmpfs none /dev
mount -t sysfs none /sys
mount -t xfs /dev/sda /mnt/xfs
#mount -t ext4 /dev/sdb /mnt/ext4

echo 0 > /proc/sys/kernel/printk

exec /bin/sh -i
EOF

# prepare initramfs
cat > ${INITRAMFS_DESC} << EOF
file /init ${INIT_NAME} 0755 0 0
dir /proc 755 0 0
dir /var 755 0 0
dir /sys 755 0 0
dir /var 755 0 0
dir /mnt 755 0 0
dir /bin 0755 0 0
dir /mnt/root 755 0 0
dir /mnt/xfs 755 0 0
#dir /mnt/ext4 755 0 0
dir /sbin 0755 0 0
dir /usr 0755 0 0
dir /usr/bin 0755 0 0
dir /usr/sbin 0755 0 0
dir /dev 755 0 0
dir /root 700 0 0
dir /etc 755 0 0
dir /lib 755 0 0
dir /lib/modules 755 0 0
dir /lib/modules/${KERNEL_VERSION} 755 0 0
nod /dev/zero 0666 0 0 c 1 5
file /sbin/busybox /sbin/busybox 0755 0 0
slink /bin/sh /sbin/busybox 0755 0 0
file /lib/modules/${KERNEL_VERSION}/xfs.ko ../fs/xfs/xfs.ko 0755 0 0
file /lib/modules/${KERNEL_VERSION}/libcrc32c.ko ../lib/libcrc32c.ko 0755 0 0
EOF

../usr/gen_init_cpio ${INITRAMFS_DESC} | gzip >initramfs.gz

#cleanup
rm ${INITRAMFS_DESC}
rm ${INIT_NAME}
