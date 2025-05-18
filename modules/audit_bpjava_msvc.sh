#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_bpjava_msvc
#
# Turn off bpjava-msvc if not required. It is associated with NetBackup.
#.

audit_bpjava_msvc () {
  print_module "audit_bpjava_msvc"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      verbose_message     "BPJava Service" "check"
      check_sunos_service "svc:/network/bpjava-msvc/tcp:default" "disabled"
    fi
  fi
}
