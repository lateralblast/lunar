#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_print
#
# Refer to Section(s) 3.14    Page(s) 14-15 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.1-2 Page(s) 34-36 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.1.7   Page(s) 22    CIS Solaris 10 Benchmark v5.1.0
#.

audit_print () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Printing Daemons" "check"
    if [ "$os_name" = "AIX" ]; then
      check_itab "qdaemon" "off"
      check_itab "lpd"     "off"
      check_itab "piobe"   "off"
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        check_sunos_service "svc:/application/print/ipp-listener:default" "disabled"
        check_sunos_service "svc:/application/print/rfc1179"              "disabled"
        check_sunos_service "svc:/application/print/server:default"       "disabled"
      fi
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file_value "is" "/etc/rc.conf" "lpd_enable" "eq" "NO" "hash"
    fi
  fi
}
