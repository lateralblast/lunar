#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_service_tags
#
# Turn off Service Tags if not being used. It can provide information that can
# be used as vector of attack.
#.

audit_service_tags () {
  print_module "audit_service_tags"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      verbose_message     "Service Tags Daemons"              "check"
      check_sunos_service "svc:/network/stdiscover:default"   "disabled"
      check_sunos_service "svc:/network/stlisten:default"     "disabled"
      check_sunos_service "svc:/application/stosreg:default"  "disabled"
    fi
  fi
}
