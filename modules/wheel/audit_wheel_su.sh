#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_wheel_su
#
# Make sure su has a wheel group ownership
#.

audit_wheel_su () {
  print_function "audit_wheel_su"
  string="Wheel group ownership"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "Darwin" ]; then
    command="command -v su 2> /dev/null"
    command_message "${command}"
    check_file=$( eval "${command}" )
    check_file_perms "${check_file}" "4750" "root" "${wheel_group}"
  else
    na_message "${string}"
  fi
}
