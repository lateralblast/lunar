#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ldap_cache
#
# Check LDAP cache
#
# Refer to Section(s) 2.2.5 Page(s) 25-6 CIS Solaris 10 Benchmark v5.1.0
#.

audit_ldap_cache () {
  print_function "audit_ldap_cache"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    verbose_message "LDAP Cache" "check"
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ]; then
        check_sunos_service "svc:/network/ldap/client" "disabled"
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_linux_service   "ldap" "off"
    fi
  fi
}
