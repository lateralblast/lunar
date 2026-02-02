#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_xen
#
# Turn off Xen services if they are not being used.
#.

audit_xen () {
  print_function "audit_xen"
  string="Xen Daemons"
  check_message "${string}"
  if [ "${os_name}" = "Linux" ]; then
    for service_name in xend xendomains; do
      check_linux_service "${service_name}" "off"
    done
  else
    na_message "${string}"
  fi
}
