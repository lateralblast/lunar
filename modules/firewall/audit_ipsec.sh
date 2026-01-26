#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ipsec
#
# Turn off IPSEC
#.

audit_ipsec () {
  print_function "audit_ipsec"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      verbose_message     "IPSEC Services" "check"
      check_sunos_service "svc:/network/ipsec/manual-key:default" "disabled"
      check_sunos_service "svc:/network/ipsec/ike:default"        "disabled"
      check_sunos_service "svc:/network/ipsec/ipsecalgs:default"  "disabled"
      check_sunos_service "svc:/network/ipsec/policy:default"     "disabled"
    fi
  fi
}
