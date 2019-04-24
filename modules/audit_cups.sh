# audit_cups
#
# Refer to Section(s) 3.4   Page(s) 61   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.4   Page(s) 73-4 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.4   Page(s) 64   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.4 Page(s) 104  CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 6.3   Page(s) 53-4 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.2.4 Page(s) 96   CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.3 Page(s) 104  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_cups () {
  if [ "$os_name" = "Linux" ]; then
    check_rpm cups
    if [ "$rpm_check" = "cups" ]; then
      verbose_message "Printing Services"
      service_name="cups"
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
      service_name="cups-lpd"
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
      service_name="cupsrenice"
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
      check_file="/etc/init.d/cups"
      check_file_perms $check_file 0744 root root
      check_file="/etc/cups/client.conf"
      check_file_perms $check_file 0644 root lp
      check_file="/etc/cups/cupsd.conf"
      check_file_perms $check_file 0600 lp sys
      check_file_value is $check_file User space lp hash
      check_file_value is $check_file Group space sys hash
      check_systemctl_service disable cups
    fi
  fi
}
