# audit_print
#
# Refer to Section(s) 3.14    Page(s) 14-15 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.1-2 Page(s) 34-36 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.1.7   Page(s) 22    CIS Solaris 10 Benchmark v5.1.0
#.

audit_print () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Printing Daemons"
    if [ "$os_name" = "AIX" ]; then
      check_itab qdaemon off
      check_itab lpd off
      check_itab piobe off
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        service_name="svc:/application/print/ipp-listener:default"
        check_sunos_service $service_name disabled
        service_name="svc:/application/print/rfc1179"
        check_sunos_service $service_name disabled
        service_name="svc:/application/print/server:default"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/rc.conf"
      check_file_value is $check_file lpd_enable eq NO hash
    fi
  fi
}
