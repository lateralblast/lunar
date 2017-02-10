# audit_gss
#
# Refer to Section(s) 2.7   Page(s) 19-20 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 2.2.7 Page(s) 27    CIS Solaris 10 Benchmark v5.1.0
#.

audit_gss () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "Generic Security Services"
      service_name="svc:/network/rpc/gss"
      check_sunos_service $service_name disabled
    fi
  fi
}
