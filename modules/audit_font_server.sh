#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_font_server
#
# Turn off font server
#.

audit_font_server () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Font Server" "check"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        for service_name in "svc:/application/x11/xfs:default" \
          "svc:/application/font/stfsloader:default" \
          "svc:/application/font/fc-cache:default"; do
          check_sunos_service "$service_name" "disabled"
        done
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      for service_name in xfs; do
        check_linux_service "$service_name" "off"
      done
    fi
  fi
}
