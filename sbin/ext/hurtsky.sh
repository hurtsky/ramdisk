#!/system/bin/sh

#
# Kernel customizations post initialization
# Created by Christopher83 all credit goes to him
# Adapted for Hurtsky's Kernel usage

# Mount system for read and write
echo "Mount system for read and write"
mount -o rw,remount /system
echo

#
# Fast Random Generator (frandom) support at boot
#
if [ -f "/lib/modules/frandom.ko" ]; then
	# Load frandom module if not built inside the zImage
	echo "Fast Random Generator (frandom): Loading module..."
	insmod /lib/modules/frandom.ko
fi
if [ -c "/dev/frandom" ]; then
	# Redirect random and urandom generation to frandom char device
	echo "Fast Random Generator (frandom): Initializing..."
	rm -f /dev/random
	rm -f /dev/urandom
	ln /dev/frandom /dev/random
	ln /dev/frandom /dev/urandom
	chmod 0666 /dev/random
	chmod 0666 /dev/urandom
	echo "Fast Random Generator (frandom): Ready!"
	echo
else
	echo "Fast Random Generator (frandom): Not supported!"
	echo
fi

#
# VM tweaks
#
if [ -d /proc/sys/vm ]; then
	echo "Setting VM tweaks..."
	echo "50" > /proc/sys/vm/dirty_ratio
	echo "10" > /proc/sys/vm/dirty_background_ratio
	echo "90" > /proc/sys/vm/vfs_cache_pressure
	echo "500" > /proc/sys/vm/dirty_expire_centisecs

	if [ -f /proc/sys/vm/dynamic_dirty_writeback ]; then
		echo "3000" > /proc/sys/vm/dirty_writeback_active_centisecs
		echo "1000" > /proc/sys/vm/dirty_writeback_suspend_centisecs
	else
		echo "1000" > /proc/sys/vm/dirty_writeback_centisecs
	fi

	echo
fi

#
# Processes to be preserved from killing
#
if [ -f /sys/module/lowmemorykiller/parameters/donotkill_proc ]; then
	echo "Setting user processes to be preserved from killing..."
	echo 1 > /sys/module/lowmemorykiller/parameters/donotkill_proc
	echo "com.cyanogenmod.trebuchet,android.inputmethod.latin," > /sys/module/lowmemorykiller/parameters/donotkill_proc_names
fi
if [ -f /sys/module/lowmemorykiller/parameters/donotkill_sysproc ]; then
	echo "Setting system processes to be preserved from killing..."
	echo 1 > /sys/module/lowmemorykiller/parameters/donotkill_sysproc
	echo "android.process.acore,com.android.phone," > /sys/module/lowmemorykiller/parameters/donotkill_sysproc_names
fi

# Mount system read-only
echo "Mount system read-only"
mount -o ro,remount /system
