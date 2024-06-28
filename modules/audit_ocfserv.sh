#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_ocfserv
#
# Turn off ocfserv
#.

audit_ocfserv () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message     "OCF Service" "check"
      check_sunos_service "svc:/network/rpc/ocfserv:default" "disabled"
    fi
  fi
}
