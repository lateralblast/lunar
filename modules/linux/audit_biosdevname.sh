#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_biosdevname
#
# Check BIOS dev names
#
# Refer to Section(s) 6.17 Page(s) 64 SLES 11 Benchmark v1.0.0
#.

audit_biosdevname () {
  print_function "audit_biosdevname"
  string="BIOS Devname"
  check_message "${string}"
  if [ "${os_name}" = "Linux" ]; then
    if [ "${os_vendor}" = "SuSE" ]; then
      check_linux_package "uninstall" "biosdevname"
    fi
  else
    na_message "${string}"
  fi
}
