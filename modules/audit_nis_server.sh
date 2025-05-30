#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_nis_server
#
# Check NIS daemon settings
#
# Refer to Section(s) 2.1.7   Page(s) 51-52 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.6   Page(s) 58-9  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.6   Page(s) 53-4  CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.16  Page(s) 117   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 5.1.1   Page(s) 40    CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 3.12-3  Page(s) 13-14 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.4     Page(s) 17-8  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 2.2.2   Page(s) 23-4  CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 2.2.16  Page(s) 109   CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.17  Page(s) 118   CIS Ubuntu 16.04 Benchmark v2.0.0
# Refer to Section(s) 2.1.10  Page(s) 254-6 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_nis_server () {
  print_function "audit_nis_server"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ]; then
    verbose_message "NIS Server Daemons" "check"
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ]; then
        for service_name in "svc:/network/nis/server" \
          "svc:/network/nis/passwd" "svc:/network/nis/update" \
          "svc:/network/nis/xfr"; do
          check_sunos_service "${service_name}" "disabled"
        done
      fi
      if [ "${os_version}" = "11" ]; then
        check_sunos_service "svc:/network/nis/server" "disabled"
        check_sunos_service "svc:/network/nis/domain" "disabled"
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      for service_name in yppasswdd ypserv ypxfrd; do
        check_linux_service "${service_name}" "off"
        check_linux_package "uninstall"     "${service_name}"
      done
    fi
    if [ "${os_name}" = "FreeBSD" ]; then
      check_file_value "is" "/etc/rc.conf" "nis_server_enable"    "eq" "NO" "hash"
      check_file_value "is" "/etc/rc.conf" "nis_ypxfrd_enable"    "eq" "NO" "hash"
      check_file_value "is" "/etc/rc.conf" "nis_yppasswdd_enable" "eq" "NO" "hash"
      check_file_value "is" "/etc/rc.conf" "rpc_ypupdated_enable" "eq" "NO" "hash"
      check_file_value "is" "/etc/rc.conf" "nis_client_enable"    "eq" "NO" "hash"
      check_file_value "is" "/etc/rc.conf" "nis_ypset_enable"     "eq" "NO" "hash"
    fi
  fi
}
