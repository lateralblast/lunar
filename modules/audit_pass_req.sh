# audit_pass_req
#
# Set PASSREQ to YES in /etc/default/login to prevent users from loging on
# without a password
#.

audit_pass_req () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "Ensure password required"
    check_file="/etc/default/login"
    check_file_value is $check_file PASSREQ eq YES hash
  fi
}
