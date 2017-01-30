# audit_kerberos_tgt
#
# Refer to Section(s) 2.6   Page(s) 19   CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 2.2.6 Page(s) 26-7 CIS Solaris 10 Benchmark v5.1.0
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
