# audit_ldap
#
# Turn off ldap
#.

audit_ldap () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "LDAP Client"
      service_name="svc:/network/ldap/client:default"
      funct_service $service_name disabled
    fi
  fi
}
