#!/bin/bash
#设置环境

# 交叉编译器路径
export PATH=$PATH:/home/coconutat/github/proton-clang-master/bin
export CC=clang
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-

export ARCH=arm64
export SUBARCH=arm64
# export DTC_EXT=dtc

if [ ! -d "out" ]; then
	mkdir out
fi

date="$(date +%Y.%m.%d-%I:%M)"

make ARCH=arm64 O=out CC=clang r6p_nodtb_ksu_defconfig
# 定义编译线程数
make ARCH=arm64 O=out $EV -j12 CC=clang 2>&1 | tee kernel_log-${date}.txt

if [ -f out/arch/arm64/boot/Image.gz ]; then
	echo "***Packing kernel...***"
	cp out/arch/arm64/boot/Image.gz Image.gz
	cp out/arch/arm64/boot/Image.gz AnyKernel3/Image.gz
	cd AnyKernel3
	zip -r9 OPPO_RENO6_PRO_KSU-${date}.zip * > /dev/null
	cd ../..
	mv AnyKernel3/OPPO_RENO6_PRO_KSU-${date}.zip OPPO_RENO6_PRO_KSU-${date}.zip
	rm -rf AnyKernel3/Image.gz

	echo " "
	echo "***Sucessfully built kernel...***"
	echo " "
	exit 0
else
	echo " "
	echo "***Failed!***"
	exit 0
fi
