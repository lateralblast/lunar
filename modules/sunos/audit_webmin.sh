#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_webmin
#
# Turn off webmin if it is not being used.
#.

audit_webmin () {
  print_function "audit_webmin"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      verbose_message     "Webmin Daemon"                              "check"
      check_sunos_service "svc:/application/management/webmin:default" "disabled"
    fi
  fi
}
