# audit_nisplus
#
# Refer to Section(s) 2.2.4 Page(s) 25 CIS Solaris 10 Benchmark v5.1.0
#.

audit_nisplus () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      verbose_message "NIS+ Daemons"
      service_name="svc:/network/rpc/nisplus"
      check_sunos_service $service_name disabled
    fi
  fi
}
