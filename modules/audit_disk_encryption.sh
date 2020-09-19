# audit_disk_encryption
#
# Check Disk Encryption is enabled
#
# Refer to Section(s) 2.6.1 Page(s) 54 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_disk_encryption () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Disk Encryption"
    if [ "$audit_mode" != 2 ]; then
      check=$( diskutil cs list | grep -i encryption | grep AES-XTS )
      if [ "$check" ]; then
        increment_secure "Disk encryption is enabled"
      else
        increment_insecure "Disk encryption is not enabled"
      fi
    fi
  fi
}
