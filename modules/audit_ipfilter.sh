#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ipfilter
#
# Turn off IP filter
#.

audit_ipfilter () {
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      verbose_message     "IP Filter" "check"
      check_sunos_service "svc:/network/ipfilter:default" "disabled"
      check_sunos_service "svc:/network/pfil:default"     "disabled"
    fi
  fi
}
