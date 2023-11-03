# audit_apport
#
# Check Automatic Error Reporting
#
# Refer to Section(s) 1.5.3 Page(s) 124 CIS Ubuntu 22.04 Benchmark v1.0.0
#.

audit_apport () {
  if [ "$os_vendor" = "Ubuntu" ] && [ "$os_version" -ge 22 ]; then
    verbose_message "Automatic Error Reporting"
    check_file="/etc/default/apport"
    check_file_value is $check_file enabled eq 0
    service_name="apport"
    check_linux_service $service_name off
  fi
}
