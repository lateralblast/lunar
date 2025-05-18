#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_keyserv
#
# Refer to Section(s) 2.3   Page(s) 16-17 CIS Solaris 11.1  Benchmark v1.0.0
# Refer to Section(s) 2.2.1 Page(s) 23    CIS Solaris 10    Benchmark v5.1.0
#.

audit_keyserv () {
  print_module "audit_keyserv"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      verbose_message     "RPC Encryption Key"
      check_sunos_service "svc:/network/rpc/keyserv" "disabled"
    fi
  fi
}
