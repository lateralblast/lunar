#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ssh_forwarding
#
# This one is optional, generally required for apps
#
# Refer to Section(s) 11.1 Page(s) 142-3 CIS Solaris 10 Benchmark v1.1.0
#.

audit_ssh_forwarding () {
  print_function "audit_ssh_forwarding"
  string="SSH Forwarding"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "Darwin" ]; then
    if [ "${os_name}" = "Darwin" ]; then
      check_file="/etc/sshd_config"
    else
      check_file="/etc/ssh/sshd_config"
    fi
    check_file_value "is" "${check_file}" "AllowTcpForwarding" "space" "no" "hash"
  else
    na_message "${string}"
  fi
}
