#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_winbind
#
# Turn off winbind if not required
#.

audit_winbind () {
  print_function "audit_winbind"
  string="Winbind Daemon"
  check_command "${string}"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      check_sunos_service "svc:/network/winbind:default" "disabled"
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_linux_service "winbind" "off"
    fi
  else
    na_message "${string}"
  fi
}
