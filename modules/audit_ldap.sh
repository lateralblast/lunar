#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ldap
#
# Turn off ldap
#
# Refer to Section(s) 2.3.5 Page(s) 115   CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.3.5 Page(s) 128   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 2.3.3 Page(s) 121   CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 2.2.5 Page(s) 300-1 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_ldap () {
  print_function "audit_ldap"
  if [ "${os_name}" = "Linux" ] || [ "${os_name}" = "SunOS" ]; then
    verbose_message "LDAP Client" "check"
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
        check_sunos_service "svc:/network/ldap/client:default" "disabled"
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_linux_package   "uninstall" "openldap-clients"
      check_linux_package   "uninstall" "ldap-utils"
    fi
  fi
}
