# audit_ldap
#
# Turn off ldap
#
# Refer to Section(s) 2.3.5 Page(s) 115 CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.3.5 Page(s) 128 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 2.3.3 Page(s) 121 CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_ldap () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "SunOS" ]; then
    verbose_message "LDAP Client"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/network/ldap/client:default"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      check_linux_package uninstall openldap-clients
    fi
  fi
}
