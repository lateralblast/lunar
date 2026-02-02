#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_vopied
#
# Veritas Online Passwords In Everything
#
# Turn off vopied if not required. It is associated with Symantec products.
#.

audit_vopied () {
  print_function "audit_vopied"
  string="VOPIE Daemon"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      check_sunos_service "svc:/network/vopied/tcp:default" "disabled"
    fi
  else
    na_message "${string}"
  fi
}
