#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_cron_logging
#
# Check cron logging
#
# Refer to Section(s) 4.7 Page(s) 71 CIS Solaris 10 Benchmark v5.1.0
#.

audit_cron_logging () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      verbose_message  "Cron Logging" "check"
      check_file_value "is" "/etc/default/cron" "CRONLOG" "eq" "YES" "hash"
      check_file_perms "/var/cron/log" "0640" "root" "root"
    fi
  fi
}
