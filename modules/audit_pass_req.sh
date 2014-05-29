# audit_pass_req
#
# Set PASSREQ to YES in /etc/default/login to prevent users from loging on
# without a password
#.

audit_pass_req () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Ensure password required"
    check_file="/etc/default/login"
    funct_file_value $check_file PASSREQ eq YES hash
  fi
}
