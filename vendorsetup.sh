#!/usr/bin/env bash
#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2020-2021 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#

FDEVICE="evergo"
#set -o xtrace

fox_get_target_device() {
	local chkdev=$(echo "$BASH_SOURCE" | grep -w $FDEVICE)
	if [ -n "$chkdev" ]; then
		FOX_BUILD_DEVICE="$FDEVICE"
	else
		chkdev=$(set | grep BASH_ARGV | grep -w $FDEVICE)
		[ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
	fi
}

if [ -z "$1" ] && [ -z "$FOX_BUILD_DEVICE" ]; then
	fox_get_target_device
fi

# Dirty Fix: Only declare orangefox vars when needed
if [ -f "$(gettop)/bootable/recovery/orangefox.cpp" ]; then
	echo -e "\x1b[96m[INFO]: Setting up OrangeFox build vars for evergo...\x1b[m"
	if [ "$1" = "$FDEVICE" ] || [  "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
		# Version / Maintainer infos
		export OF_MAINTAINER="weaponmasterjax&jignesh"
		export FOX_VERSION=R12.2
		export FOX_BUILD_TYPE="Beta"
		export FOX_VARIANT=MIUI1404IN
		
  		# Device info
		export FOX_AB_DEVICE=1
		export FOX_VIRTUAL_AB_DEVICE=1
		export TARGET_DEVICE_ALT="evergreen, evergo, opal, everpal"
		
		# OTA / DM-Verity / Encryption
		export OF_DISABLE_MIUI_OTA_BY_DEFAULT=1
		export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR=1
		
		export OF_DONT_PATCH_ON_FRESH_INSTALLATION=1
		export OF_DONT_PATCH_ENCRYPTED_DEVICE=1
		export OF_KEEP_DM_VERITY_FORCED_ENCRYPTION=1
		export OF_SKIP_FBE_DECRYPTION_SDKVERSION=34 # We all know what happens
		export OF_SKIP_DECRYPTED_ADOPTED_STORAGE=1
  		
    		＃ Keymaster
  		export OF_DEFAULT_KEYMASTER_VERSION=4.1

  	        # MediaTek
	        export FOX_RECOVERY_BOOT_PARTITION="/dev/block/by-name/boot"
  		export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
		export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"

                # Display / Leds
		export OF_SCREEN_H="2400"
		export OF_STATUS_H="100"
		export OF_STATUS_INDENT_LEFT=48
		export OF_STATUS_INDENT_RIGHT=48
		export OF_HIDE_NOTCH=1
		export OF_CLOCK_POS=1 # left and right clock positions available
		export OF_USE_GREEN_LED=0

		
  		# Flashlight
	        export OF_FL_PATH1="/system/flashlight"
		
		# Other OrangeFox configs
		export OF_ENABLE_LPTOOLS=1
  		export FOX_ENABLE_APP_MANAGER=1
		export OF_ALLOW_DISABLE_NAVBAR=0
                export OF_QUICK_BACKUP_LIST="/boot;/data;"
		export FOX_BUGGED_AOSP_ARB_WORKAROUND="1546300800" # Tue Jan 1 2019 00:00:00 GMT
        	export FOX_USE_BASH_SHELL=1
	        export FOX_ASH_IS_BASH=1
	        export FOX_USE_TAR_BINARY=1
	        export FOX_USE_SED_BINARY=1
	        export FOX_USE_XZ_UTILS=1
	        export FOX_USE_NANO_EDITOR=1

  		# Magisk
		function download_magisk(){
			# Usage: download_magisk <destination_path>
			local DEST=$1
			if [ -n "${DEST}" ]; then
				if [ ! -e ${DEST} ]; then
					echo "Downloading the Latest Release of Magisk..."
					local LATEST_MAGISK_URL=$(curl -sL https://api.github.com/repos/topjohnwu/Magisk/releases/latest | grep "browser_download_url" | grep ".apk" | cut -d : -f 2,3 | tr -d '"')
					mkdir -p $(dirname ${DEST})
					wget -q ${LATEST_MAGISK_URL} -O ${DEST} || wget ${LATEST_MAGISK_URL} -O ${DEST}
					local RCODE=$?
					if [ "$RCODE" = "0" ]; then
						echo "Successfully Downloaded Magisk to ${DEST}!"
						echo "Done!"
					else
						echo "Failed to Download Magisk to ${DEST}!"
					fi
				fi
			fi
		}
		export FOX_USE_SPECIFIC_MAGISK_ZIP=~/Magisk/Magisk.zip
		download_magisk $FOX_USE_SPECIFIC_MAGISK_ZIP

  
    fi
fi
