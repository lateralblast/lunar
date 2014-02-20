# audit_kerberos_tgt
#
# While Kerberos can be a security enhancement, if the local site is
# not currently using Kerberos then there is no need to have the
# Kerberos TGT expiration warning enabled.
#.

audit_kerberos_tgt () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Kerberos Ticket Warning"
      service_name="svc:/network/security/ktkt_warn"
      funct_service $service_name disabled
    fi
  fi
}
