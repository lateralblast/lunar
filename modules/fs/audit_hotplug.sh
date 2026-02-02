#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_hotplug
#
# Turn off hotplug
#.

audit_hotplug () {
  print_function "audit_hotplug"
  string="Hotplug Service"
  check_command "${string}"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
        check_sunos_service "svc:/system/hotplug:default" "disabled"
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      for service_name in pcscd haldaemon kudzu; do
        check_linux_service "${service_name}" "off"
      done
    fi
  else
    na_message "${string}"
  fi
}
