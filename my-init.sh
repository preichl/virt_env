#!/sbin/busybox sh


echo "INIT SCRIPT" 

echo "install buxybox..." 
/sbin/busybox --install -s

insmod /lib/modules/5.7.0-rc1/libcrc32c.ko 
insmod /lib/modules/5.7.0-rc1/xfs.ko 

mount -t proc none /proc
mount -t devtmpfs none /dev
mount -t sysfs none /sys

mount -t xfs /dev/sda /mnt/xfs
mount -t ext4 /dev/sdb /mnt/ext4

echo 0 > /proc/sys/kernel/printk

exec /bin/sh -i
