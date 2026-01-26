#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_service
#
# Service audit routine wrapper, sends to appropriate function based on service type
#
# service_name    = Name of service
# correct_status  = What the status of the service should be, ie enable/disabled
#.

check_service () {
  print_function "check_service"
  if [ "${os_name}" = "SunOS" ]; then
    service_name="$1"
    correct_status="$2"
    service_test=$( echo "${service_name}" |grep "svc:" )
    if [ -n "${service_test}" ]; then
      check_svcadm_service "${service_name}" "${correct_status}"
    else
      check_initd_service  "${service_name}" "${correct_status}"
      check_inetd_service  "${service_name}" "${correct_status}"
    fi
  fi
}
