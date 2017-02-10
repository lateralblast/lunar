# audit_tftp_client
#
# Refer to Section(s) 2.1.7 Page(s) 51   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.7 Page(s) 59   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.7 Page(s) 54-5 CIS RHEL 6 Benchmark v1.2.0
#.

audit_tftp_client () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "TFTP Client"
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
      check_linux_package uninstall tftp
    fi
  fi
}
