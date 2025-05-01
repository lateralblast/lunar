#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# full_audit_ftp_services
#
# Audit FTP Services

full_audit_ftp_services () {
  audit_ftp_logging
  audit_ftp_umask
  audit_ftp_conf
  audit_ftp_client
  audit_ftp_server
  audit_tftp_server
  audit_ftp_banner
}
