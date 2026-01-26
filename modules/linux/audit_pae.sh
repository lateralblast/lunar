#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_pae
#
# Check PAE settings
#
# Refer to Section(s) 1.5.1 Page(s) 88-9 CIS Ubuntu 22.04 Benchmark v1.0.0
#.

audit_pae () {
  print_function "audit_pae"
  if [ "${os_name}" = "Linux" ]; then
    verbose_message "XD/NX" "check"
    if [ -f "/var/log/dmesg" ]; then
      check_nx=$( grep NX < /var/log/dmesg | grep "protection: active" | tail -1 | grep -c active | sed "s/ //g" )
      if [ "${check_nx}" = "1" ]; then
        increment_secure   "XD/NX is enabled"
      else
        increment_insecure "XD/NX is not enabled"
      fi
    fi
  fi
}