# audit_stack_protection
#
# Stack Protection
#
# Checks for the following values in /etc/system:
#
# set noexec_user_stack=1
# set noexec_user_stack_log=1
#
# Refer to Section(s) 3.2 Page(s) 26-7 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 3.3 Page(s) 62-3 CIS Solaris 10 Benchmark v5.1.0
#.

audit_stack_protection () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "Stack Protection"
    check_file="/etc/system"
    check_file_value is $check_file "set noexec_user_stack" eq 1 star
    check_file_value is $check_file "set noexec_user_stack_log" eq 1 star
  fi
}
