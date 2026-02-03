#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_writesrv
#
# Refer to Section(s) 2.12.6 Page(s) 210-1 CIS AIX Benchmark v1.1.0
#.

audit_writesrv () {
  print_function "audit_writesrv"
  string="Writesrv"
  check_message "${string}"
  if [ "${os_name}" = "AIX" ]; then
    check_itab "writesrv" "off"
  else
    na_message "${string}"
  fi
}
