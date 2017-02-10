# audit_rsh_client
#
# Refer to Section(s) 2.1.4 Page(s) 49   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.4 Page(s) 57   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.4 Page(s) 52-3 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.3.2 Page(s) 125  CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 5.1.4 Page(s) 42-3 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.3.2 Page(s) 112  CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.3.2 Page(s) 121  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_rsh_client () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "RSH Client"
    check_linux_package uninstall rsh
  fi
}
