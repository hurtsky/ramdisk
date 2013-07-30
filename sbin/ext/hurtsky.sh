#!/system/bin/sh

#
# Kernel customizations post initialization
# Created by Christopher83 all credit goes to him
# Adapted for Hurtsky's Kernel usage

# Mount system for read and write
echo "Mount system for read and write"
mount -o rw,remount /system
echo

# Adding Scripts

# Mount system read-only
echo "Mount system read-only"
mount -o ro,remount /system
