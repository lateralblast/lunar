#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_tftp_client
#
# Turn off TFTP
#
# Refer to Section(s) 2.1.7 Page(s) 51   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.7 Page(s) 59   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.7 Page(s) 54-5 CIS RHEL 6 Benchmark v1.2.0
#.

audit_tftp_client () {
  print_function "audit_tftp_client"
  string="TFTP Client"
  check_message "${string}"
  if [ "${os_name}" = "Linux" ]; then
    if [ "${os_vendor}" = "CentOS" ] || [ "${os_vendor}" = "Red" ]; then
      check_linux_package "uninstall" "tftp"
    fi
  else
    na_message "${string}"
  fi
}
