#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# full_audit_log_services
#
# Audit log files and log related services
#.

full_audit_log_services () {
  audit_syslog_server
  audit_linux_logfiles
  audit_syslog_conf
  audit_debug_logging
  audit_syslog_auth
  audit_core_dumps
  audit_cron_logging
  audit_logrotate
}
