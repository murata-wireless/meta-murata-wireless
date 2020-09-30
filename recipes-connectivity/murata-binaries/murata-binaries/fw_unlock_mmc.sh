# Give fw_setenv mmcblk?boot0 write permissions
function fw_setenv() {
    dev=`ls /dev/mmcblk*boot*`
    dev=($dev)
    dev=${dev[0]}
    dev=${dev#/dev/mmcblk}
    dev=${dev%boot*}
    echo 0 > /sys/block/mmcblk${dev}boot0/force_ro
    /sbin/fw_setenv "$@"
    echo 1 > /sys/block/mmcblk${dev}boot0/force_ro
}
