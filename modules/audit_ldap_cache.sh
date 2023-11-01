# audit_ldap_cache
#
# Check LDAP cache
#
# Refer to Section(s) 2.2.5 Page(s) 25-6 CIS Solaris 10 Benchmark v5.1.0
#.

audit_ldap_cache () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "LDAP Client"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        service_name="svc:/network/ldap/client"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      service_name="ldap"
      check_linux_service $service_name off
    fi
  fi
}
