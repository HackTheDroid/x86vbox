# Copyright (C) 2016 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#******************************************************************************
#
# Makefile - Make file for eclipse integration
#
# Copyright (c) 2016 Roger Ye.  All rights reserved.
#
# This is part of the build for virtual device x86vbox.
#
#******************************************************************************

initrd_dir :=  ${OUT}/../../../../bootable/newinstaller/initrd
TARGET_INSTALLER_OUT :=${OUT}/installer
ACP := acp
MKBOOTFS := mkbootfs

all:
	cd ../../..;make -j4 2>&1 | tee x86vbox-`date +%Y%m%d`.txt

x86vbox:
	cd ../../..;make -j4

snod:
	cd ../../..;make snod

initrd_img:
	cd ../../..;make initrd USE_SQUASHFS=0

ramdisk:
	cd ../../..;$(MKBOOTFS) -d ${OUT}/system ${OUT}/root | minigzip > ${OUT}/ramdisk.img

clean-ramdisk:
	rm ${OUT}/ramdisk.img
	rm -rf ${OUT}/root

installer:
	rm -rf $(TARGET_INSTALLER_OUT)/scripts
	$(ACP) -pr $(initrd_dir)/scripts $(TARGET_INSTALLER_OUT)/scripts
	$(ACP) -pr $(initrd_dir) $(TARGET_INSTALLER_OUT)
	cd ../../..;$(MKBOOTFS) $(TARGET_INSTALLER_OUT) | gzip -9 > ${OUT}/initrd.img

ramdisk-recovery:
	cd ../../..;$(MKBOOTFS) -d ${OUT}/system ${OUT}/recovery/root | minigzip > ${OUT}/ramdisk-recovery.img

recoveryimage:
	cd ../../..;make -j4 recoveryimage 2>&1 | tee x86vbox-`date +%Y%m%d`.txt

clean-recoveryimage:
	rm ${OUT}/recovery.img
	rm -rf ${OUT}/recovery/root
	rm ${OUT}/ramdisk-recovery.img
	
