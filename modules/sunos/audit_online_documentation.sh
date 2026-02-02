#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_online_documentation
#
# Check online documentation daemon settings
#
# Refer to Section(s) 2.12.4 Page(s) 209 CIS AIX Benchmark v1.1.0
#.

audit_online_documentation () {
  print_function "audit_online_documentation"
  string="Online Documentation"
  check_message "${string}"
  if [ "${os_name}" = "AIX" ] || [ "${os_name}" = "SunOS" ]; then
    if [ "${os_name}" = "AIX" ]; then
      check_itab "httpdlite" "off"
    fi
    if [ "${os_name}" = "SunOS" ]; then
      check_initd_service "ab2mgr" "disabled"
    fi
  else
    na_message "${string}"
  fi
}
