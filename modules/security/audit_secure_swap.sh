#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_secure_swap
#
# Check secure swap settings
#
# Refer to Section(s) 1.4.13.6 Page(s) 47-8 CIS Apple OS X 10.6 Benchmark v1.0.0
#.

audit_secure_swap () {
  print_function "audit_secure_swap"
  string="Secure Swap"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    check_osx_defaults_bool "/Library/Preferences/com.apple.virtualMemory" "UseEncryptedSwap" "yes"
  else
    na_message "${string}"
  fi
}
