#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154
# shellcheck disable=SC2196

# audit_core_storage
#
# Ensure all user core storage volumes are encrypted
#
# Refer to Section(s) 5.3.2 Page(s) 339-42 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_core_storage () {
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      verbose_message "Core Storage Volumes" "check"
      if [ "${audit_mode}" != 2 ]; then
        insecure_vols=$( diskutil cs list |egrep -v "Snapshot|Not Mounted|Sealed|Capacity" |grep -A1 "/" |grep -v "\-" |sed "s/\|//g" |sed "s/ //g" |grep -B1 "FileVault:No" |grep "MountPoint" |cut -f2 -d: )
        for volume in ${insecure_vols}; do
          increment_insecure "Core Storage Volume \"${volume}\" is not encrypted"
        done
        secure_vols=$( diskutil cs list |egrep -v "Snapshot|Not Mounted|Sealed|Capacity" |grep -A1 "/" |grep -v "\-" |sed "s/\|//g" |sed "s/ //g" |grep -B1 "FileVault:Yes" |grep "MountPoint" |cut -f2 -d: )
        for volume in ${secure_vols}; do
          increment_secure   "Core Storage Volume \"${volume}\" is encrypted"
        done
      fi
    fi
  fi
}
