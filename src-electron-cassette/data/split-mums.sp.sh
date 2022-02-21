dd if=mums.sp bs=1 status=none skip=$((0x000)) count=$((0x60)) of=mums.sp1
dd if=mums.sp bs=1 status=none skip=$((0x060)) count=$((0x60)) of=mums.sp2
dd if=mums.sp bs=1 status=none skip=$((0x0C0)) count=$((0x60)) of=mums.sp3
dd if=mums.sp bs=1 status=none skip=$((0x120)) count=$((0x60)) of=mums.sp4
dd if=mums.sp bs=1 status=none skip=$((0x180)) count=$((0x60)) of=mums.sp5
