# audit_apfs
#
# Ensure all user storage APFS volumes are encrypted
#
# Refer to Section(s) 2.3.1.1 Page(s) 72-6 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_apfs () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "APFS Volumes"
      if [ "$audit_mode" != 2 ]; then
        insecure_vols=$( diskutil ap list |egrep -v "Snapshot|Not Mounted|Sealed|Capacity" |grep -A1 "/" |grep -v "\-" |sed "s/\|//g" |sed "s/ //g" |grep -B1 "FileVault:No" |grep "MountPoint" |cut -f2 -d: )
        for volume in $insecure_vols; do
          increment_insecure "APFS Volume $volume is not encrypted"
        done
        secure_vols=$( diskutil ap list |egrep -v "Snapshot|Not Mounted|Sealed|Capacity" |grep -A1 "/" |grep -v "\-" |sed "s/\|//g" |sed "s/ //g" |grep -B1 "FileVault:Yes" |grep "MountPoint" |cut -f2 -d: )
        for volume in $secure_vols; do
          increment_secure "APFS Volume $volume is encrypted"
        done
      fi
    fi
  fi
}
