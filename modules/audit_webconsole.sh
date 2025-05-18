#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_webconsole
#
# Turn of Web Console service
#
# Refer to Section(s) 2.1.5 Page(s) 20-1 CIS Solaris 10 Benchmark v5.1.0
#.

audit_webconsole () {
  print_module "audit_webconsole"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      verbose_message     "Web Console"                    "check"
      check_sunos_service "svc:/system/webconsole:console" "disabled"
    fi
  fi
}
