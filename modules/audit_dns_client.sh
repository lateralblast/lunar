#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_dns_client
#
# Turn off Name Server Caching Daemon
#.

audit_dns_client () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message     "Name Server Caching Daemon" "check"
    check_linux_service "nscd" "off"
  fi
}
