# audit_ldap_server
#
# Refer to Section(s) 3.7   Page(s) 63-4 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.7   Page(s) 76   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.7   Page(s) 66-7 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.6 Page(s) 106  CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 6.6   Page(s) 56-7 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.2.6 Page(s) 98   CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.6 Page(s) 106  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_ldap_server () {
  if [ "$os_name" = "Linux" ]; then
    verbose_mesage "LDAP Server"
    check_systemctl_service disable slapd
    check_linux_package uninstall openldap-clients
  fi
}
