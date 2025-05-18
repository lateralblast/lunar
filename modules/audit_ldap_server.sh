#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ldap_server
#
# Check LDAP server
#
# Refer to Section(s) 3.7   Page(s) 63-4  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.7   Page(s) 76    CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.7   Page(s) 66-7  CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.6 Page(s) 106   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 6.6   Page(s) 56-7  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.2.6 Page(s) 98    CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.6 Page(s) 106   CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 2.1.7 Page(s) 245-6 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_ldap_server () {
  print_module "audit_ldap_server"
  if [ "${os_name}" = "Linux" ]; then
    verbose_mesage      "LDAP Server" "check"
    check_linux_service "slapd"       "off"
    check_linux_package "uninstall"   "slapd"
  fi
}
