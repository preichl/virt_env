#!/bin/bash

qemu-kvm -kernel ../arch/x86/boot/bzImage \
-m 4G \
-initrd initramfs.gz \
-append "console=ttyS0" \
-hda ~/vms/xfs_image/xfs_image.raw \
-nographic
