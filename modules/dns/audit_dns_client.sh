#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_dns_client
#
# Turn off Name Server Caching Daemon
#.

audit_dns_client () {
  print_function "audit_dns_client"
  string="Name Server Caching Daemon"
  check_message "${string}"
  if [ "${os_name}" = "Linux" ]; then
    check_linux_service "nscd" "off"
  else
    na_message "${string}"
  fi
}
