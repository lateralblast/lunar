#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_echo
#
# Turn off echo and chargen services
#.

audit_echo () {
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      verbose_message "Echo and Chargen Services" "check"
      for service_name in "svc:/network/echo:dgram" \
        "svc:/network/echo:stream" "svc:/network/time:dgram" \
        "svc:/network/time:stream" "svc:/network/tname:default" \
        "svc:/network/comsat:default" "svc:/network/discard:dgram" \
        "svc:/network/discard:stream" "svc:/network/chargen:dgram" \
        "svc:/network/chargen:stream" "svc:/network/rpc/spray:default" \
        "svc:/network/daytime:dgram" "svc:/network/daytime:stream" \
        "svc:/network/talk:default"; do
        check_sunos_service "${service_name}" "disabled"
      done
    fi
  fi
#  if [ "${os_name}" = "Linux" ]; then
#    verbose_message "Telnet and Rlogin Services"
#    for service_name in telnet login rlogin rsh shell; do
#      check_linux_service ${service_name} off
#    done
#  fi
}
