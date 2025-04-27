#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_xen
#
# Turn off Xen services if they are not being used.
#.

audit_xen () {
  if [ "${os_name}" = "Linux" ]; then
    verbose_message "Xen Daemons" "check"
    for service_name in xend xendomains; do
      check_linux_service "${service_name}" "off"
    done
  fi
}
