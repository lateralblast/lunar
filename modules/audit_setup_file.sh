#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_setup_file
#
# Check Setup File permissions 
#.

audit_setup_file () {
  print_module "audit_setup_file"
  if [ "${os_name}" = "Darwin" ]; then
    verbose_message  "Setup file"              "check"
    check_file_perms "/var/db/.AppleSetupDone" "0400" "root" "${wheel_group}"
  fi
}
