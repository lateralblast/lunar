# audit_krb5
#
# Turn off kerberos if not required
#.

audit_krb5 () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Kerberos"
      service_name="svc:/network/security/krb5kdc:default"
      funct_service $service_name disabled
      service_name="svc:/network/security/kadmin:default"
      funct_service $service_name disabled
      service_name="svc:/network/security/krb5_prop:default"
      funct_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Kerberos"
    for service_name in kadmin kprop krb524 krb5kdc; do
      funct_chkconfig_service $service_name 3 off
      funct_chkconfig_service $service_name 5 off
    done
  fi
}
