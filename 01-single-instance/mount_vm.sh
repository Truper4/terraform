#!/bin/bash
mkfs -t ext4 /dev/vdb
mkdir /mnt/data
mount /dev/vdb /mnt/data
echo /dev/vdb /mnt/data ext4 defaults,nofail 0 2 >> /etc/fstab