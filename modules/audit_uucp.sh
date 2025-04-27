#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_uucp
#
# Turn off uucp and swat
#.

audit_uucp () {
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      verbose_message     "Samba Web Configuration Deamon" "check"
      check_sunos_service "svc:/network/swat:defaulte" "disabled"
    fi
    if [ "${os_version}" = "10" ]; then
      verbose_message     "UUCP Service" "check"
      check_sunos_service "uucp" "disabled"
    fi
  fi
}
