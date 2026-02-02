#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_encryption_kit
#
# Check Encryption Kit
#
# Refer to Section(s) 1.3 Page(s) 15-6 CIS Solaris 10 Benchmark v5.1.0
#.

audit_encryption_kit () {
  print_function "audit_encryption_kit"
  string="Encryption Toolkit"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      check_solaris_package   "SUNWcry"
      check_solaris_package   "SUNWcryr"
      if [ "${os_update}" -le 4 ]; then
        check_solaris_package "SUNWcryman"
      fi
    fi
  else
    na_message "${string}"
  fi
}
