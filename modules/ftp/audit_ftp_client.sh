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
  string="FTP Client"
  check_message "${string}"
  if [ "${os_name}" = "Linux" ]; then
    for package in ftp tnftp; do
      check_linux_package "uninstall" "${package}"
    done
  else
    na_message "${string}"
  fi
}
