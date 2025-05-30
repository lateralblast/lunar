#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_avahi_server
#
# Check Avahi Server
#
# Refer to Section(s) 3.3   Page(s) 60    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.3   Page(s) 67    CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.3   Page(s) 63    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.3 Page(s) 103   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 6.2   Page(s) 52-3  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.2.3 Page(s) 95    CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.3 Page(s) 103   CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 2.1.2 Page(s) 231-3 CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_avahi_server () {
  print_function "audit_avahi_server"
  if [ "${os_name}" = "Linux" ]; then
    verbose_message "Avahi Server" "check"
    for service_name in avahi avahi-autoipd avahi-daemon avahi-dnsconfd; do
      check_linux_service "${service_name}" "off"
    done
  fi
}
