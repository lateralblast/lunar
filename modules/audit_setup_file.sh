# audit_setup_file
#
# Check ownership of /var/db/.AppleSetupDone
# Incorrect ownership could lead to tampering. If deleted the Administrator
# password will be reset on next boot.
#.

audit_setup_file () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Setup file"
    check_file="/var/db/.AppleSetupDone"
    funct_check_perms $check_file 0400 root $wheel_group
  fi
}
