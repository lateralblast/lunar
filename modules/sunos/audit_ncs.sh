#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ncs
#
# Check NCS
#
# Refer to Section(s) 2.12.3 Page(s) 208 CIS AIX Benchmark v1.1.0
#.

audit_ncs () {
  print_function "audit_ncs"
  string="NCS"
  check_message "${string}"
  if [ "${os_name}" = "AIX" ]; then
    check_itab "ncs" "off"
  else
    na_message "${string}"
  fi
}
