#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_vnc
#
# Turn off VNC
#.

audit_vnc () {
  print_module "audit_vnc"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    verbose_message "VNC Daemons" "check"
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
        check_sunos_service "svc:/application/x11/xvnc-inetd:default" "disabled"
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_linux_service "vncserver" "off"
    fi
  fi
}
