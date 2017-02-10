# audit_xinetd_server
#
# Refer to Section(s) 2.1.11 Page(s) 54   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.11 Page(s) 62   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.11 Page(s) 46-7 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.1.7  Page(s) 97   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 5.1.9  Page(s) 45-6 CIS SLES 11 Benchmark v1.0.0
#.

audit_xinetd_server () {
  if [ "$os_name" = "Linux" ]; then
    check_systemctl_service disable xinetd
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
      verbose_message "Xinetd Server Daemon"
      check_linux_package uninstall xinetd
    fi
  fi
}
