#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_winbind
#
# Turn off winbind if not required
#.

audit_winbind () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Winbind Daemon" "check"
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      check_sunos_service "svc:/network/winbind:default" "disabled"
    fi
    if [ "$os_name" = "Linux" ]; then
      check_linux_service "winbind" "off"
    fi
  fi
}
