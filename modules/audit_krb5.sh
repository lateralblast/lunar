# audit_krb5
#
# Turn off kerberos if not required
#.

audit_krb5 () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Kerberos"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/network/security/krb5kdc:default"
        check_sunos_service $service_name disabled
        service_name="svc:/network/security/kadmin:default"
        check_sunos_service $service_name disabled
        service_name="svc:/network/security/krb5_prop:default"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      for service_name in kadmin kprop krb524 krb5kdc; do
        check_chkconfig_service $service_name 3 off
        check_chkconfig_service $service_name 5 off
      done
    fi
  fi
}
