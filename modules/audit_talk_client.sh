# audit_talk_client
#
# Refer to Section(s) 2.1.9 Page(s) 53   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.9 Page(s) 61   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.9 Page(s) 55-6 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.3.3 Page(s) 126   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 5.2.6 Page(s) 43-4 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.3.3 Page(s) 113  CIS Amazon Linux Benchmark v2.0.0
#.

audit_talk_client () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "Amazon" ]; then
      funct_verbose_message "Talk Client"
      funct_linux_package uninstall talk
    fi
  fi
}
