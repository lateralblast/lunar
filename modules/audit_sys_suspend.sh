# audit_sys_suspend
#
# Refer to Section(s) 10.4 Page(s) 140 CIS Solaris 10 Benchmark v1.1.0
#.

audit_sys_suspend () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "System Suspend"
    check_file="/etc/default/sys-suspend"
    check_file_value is $check_file PERMS eq "-" hash
  fi
}
