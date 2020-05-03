# audit_talk_client
#
# Refer to Section(s) 2.1.9 Page(s) 53   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.9 Page(s) 61   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.9 Page(s) 55-6 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.3.3 Page(s) 126  CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 5.2.6 Page(s) 43-4 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.3.3 Page(s) 113  CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.3.3 Page(s) 122  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_talk_client () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Talk Client"
    check_linux_package uninstall talk
  fi
}
