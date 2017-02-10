# audit_setup_file
#
# Refer to Section(s) 9.23 Page(s) 134-5 CIS Solaris 10 Benchmark v1.1.0
#.

audit_setup_file () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Setup file"
    check_file="/var/db/.AppleSetupDone"
    check_file_perms $check_file 0400 root $wheel_group
  fi
}
