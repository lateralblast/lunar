#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_linux_service
#
# Code to audit a linux service managed by chkconfig, and enable, or disable
#
# service_name    = Name of service
# correct_status  = What the status of the service should be, ie enabled/disabled
#.

check_linux_service () {
  service_name="$1"
  correct_status="$2" 
  if [ "${os_name}" = "VMkernel" ] || [ "${os_name}" = "Linux" ]; then
    if [ -f "/usr/bin/systemctl" ]; then
      if [ "${correct_status}" = "on" ] || [ "${correct_status}" = "enable" ]; then
        correct_status="enable"
      else
        correct_status="disable"
      fi
      check_systemctl_service "${correct_status}"   "${service_name}"
    else
      check_chkconfig_service "${service_name}" "3" "${correct_status}"
      check_chkconfig_service "${service_name}" "5" "${correct_status}"
    fi
  fi
}
