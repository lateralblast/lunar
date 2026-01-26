#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ftp_client
#
# Refer to Section(s) 2.2.6 Page(s) 302-3 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_ftp_client () {
  print_function "audit_ftp_client"
  if [ "${os_name}" = "Linux" ]; then
    verbose_message "FTP Client" "check"
    for package in ftp tnftp; do
      check_linux_package "uninstall" "${package}"
    done
  fi
}
