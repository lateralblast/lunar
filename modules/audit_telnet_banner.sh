# audit_telnet_banner
#
# Refer to Section(s) 8.5 Page(s) 71    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 8.5 Page(s) 114-5 CIS Solaris 10 Benchmark v5.1.0
#.

audit_telnet_banner () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "Telnet Banner"
    check_file="/etc/default/telnetd"
    check_file_value is $check_file BANNER eq /etc/issue hash
  fi
}
