#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_setup_file
#
# Check Setup File permissions 
#.

audit_setup_file () {
  print_function "audit_setup_file"
  string="Setup file"
  check_command "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    check_file_perms "/var/db/.AppleSetupDone" "0400" "root" "${wheel_group}"
  else
    na_message "${string}"
  fi
}
