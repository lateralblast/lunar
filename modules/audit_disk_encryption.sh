# audit_disk_encryption
#
# Check Disk Encryption is enabled
#
# Refer to Section(s) 2.6.1 Page(s) 54 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_disk_encryption () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Disk Encryption"
    echo "Checking:  Disk encryption is enabled"
    if [ "$audit_mode" != 2 ]; then
      check=`diskutil cs list | grep -i encryption |grep AES-XTS`
      if [ "$check" ]; then
        secure=`expr $secure + 1`
        echo "Secure:    Disk encryption is enabled [$secure Passes]"
      else
        insecure=`expr $insecure + 1`
        echo "Warning:   Disk encryption is not enabled [$insecure Warnings]"
      fi
    fi
  fi
}
