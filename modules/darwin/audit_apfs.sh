#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154
# shellcheck disable=SC2196

# audit_apfs
#
# Ensure all user storage APFS volumes are encrypted
#
# Refer to Section(s) 5.3.1 Page(s) 335-8 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_apfs () {
  print_function "audit_apfs"
  string="APFS Volumes"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      if [ "${audit_mode}" != 2 ]; then
        command="diskutil ap list | grep -Ev \"Snapshot|Not Mounted|Sealed|Capacity\" | grep -A1 \"/\" | grep -v \"\-\" | sed \"s/\|//g\" | sed \"s/ //g\" | grep -B1 \"FileVault:No\" | grep \"MountPoint\" | cut -f2 -d:"
        command_message "${command}"
        insecure_vols=$( eval "${command}" )
        for volume in ${insecure_vols}; do
          increment_insecure "APFS Volume \"${volume}\" is not encrypted"
        done
        command="diskutil ap list | grep -Ev \"Snapshot|Not Mounted|Sealed|Capacity\" | grep -A1 \"/\" | grep -v \"\-\" | sed \"s/\|//g\" | sed \"s/ //g\" | grep -B1 \"FileVault:Yes\" | grep \"MountPoint\" | cut -f2 -d:"
        command_message "${command}"
        secure_vols=$( eval "${command}" )
        for volume in ${secure_vols}; do
          increment_secure "APFS Volume \"${volume}\" is encrypted"
        done
      fi
    fi
  else
    na_message "${string}"
  fi
}
