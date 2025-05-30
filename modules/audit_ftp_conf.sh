#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ftp_conf
#
# Audit FTP Configuration
#.

audit_ftp_conf () {
  print_function "audit_ftp_conf"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "AIX" ]; then
    verbose_message "FTP users" "check"
    if [ "${os_name}" = "AIX" ]; then
      audit_ftp_users "/etc/ftpusers"
    fi
    if [ "${os_name}" = "SunOS" ]; then
      audit_ftp_users "/etc/ftpd/ftpusers"
    fi
    if [ "${os_name}" = "Linux" ]; then
      audit_ftp_users "/etc/vsftpd/ftpusers"
    fi
  fi
}
