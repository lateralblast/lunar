#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_disk_encryption
#
# Check Disk Encryption is enabled
#
# Refer to Section(s) 2.6.1 Page(s) 54 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_disk_encryption () {
  if [ "${os_name}" = "Darwin" ]; then
    verbose_message "Disk Encryption" "check"
    if [ "${audit_mode}" != 2 ]; then
      disk_check=$( diskutil cs list | grep -i encryption | grep AES-XTS )
      if [ "${disk_check}" ]; then
        increment_secure   "Disk encryption is enabled"
      else
        increment_insecure "Disk encryption is not enabled"
      fi
    fi
  fi
}
