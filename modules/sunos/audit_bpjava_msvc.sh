#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_bpjava_msvc
#
# Turn off bpjava-msvc if not required. It is associated with NetBackup.
#.

audit_bpjava_msvc () {
  print_function "audit_bpjava_msvc"
  string="BPJava Service"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      check_sunos_service "svc:/network/bpjava-msvc/tcp:default" "disabled"
    fi
  else
    na_message "${string}"
  fi
}
