#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_cron
#
# Check cron
#
# Refer to Section(s) 6.1.1   Page(s) 138-9   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 6.1.1   Page(s) 121-2   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 9.1.1   Page(s) 114-5   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 5.1.1   Page(s) 192     CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 5.1.1   Page(s) 204     CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 2.4.1.1 Page(s) 329-30  CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_cron () {
  print_function "audit_cron"
  if [ "${os_name}" = "Linux" ]; then
    verbose_message       "Cron Daemon" "check"
    check_linux_service   "crond"       "on"
    if [ "${anacron_enable}" = "yes" ]; then
      check_linux_service "anacron"     "on"
    fi
  fi
}
