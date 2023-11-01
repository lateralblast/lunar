# audit_setup_file
#
# Check Setup File permissions 
#.

audit_setup_file () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Setup file"
    check_file="/var/db/.AppleSetupDone"
    check_file_perms $check_file 0400 root $wheel_group
  fi
}
