# audit_ldap
#
# Turn off ldap
#
# Refer to Section(s) 2.3.5 Page(s) 115 CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.3.5 Page(s) 128 CIS Red Hat Enterprise Linux 7 Benchmark v2.1.0
#.

audit_ldap () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "LDAP Client"
      service_name="svc:/network/ldap/client:default"
      funct_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "Amazon" ] ; then
      funct_linux_package uninstall openldap-clients
    fi
  fi
}
