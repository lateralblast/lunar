# audit_inetd
#
# Refer to Section(s) 10.6 Page(s) 141-2 CIS Solaris 10 Benchmark v1.1.0
#.

audit_inetd () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "Internet Services"
      service_name="svc:/network/inetd:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
