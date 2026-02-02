#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_talk_server
#
# Turn off talk server
#
# Refer to Section(s) 2.1.10 Page(s) 53-54 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.10 Page(s) 61-2  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.10 Page(s) 56    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.1.18 Page(s) 119   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 5.1.5  Page(s) 43    CIS SLES 11 Benchmark v1.0.0
#.

audit_talk_server () {
  print_function "audit_talk_server"
  string="Talk Server"
  check_message "${string}"
  if [ "${os_name}" = "Linux" ]; then
    if [ "${os_vendor}" = "CentOS" ] || [ "${os_vendor}" = "Red" ] || [ "${os_vendor}" = "Amazon" ]; then
      check_linux_service "ntalk"              "off"
      check_linux_package "uninstall"          "talk-server"
    fi
  else
    na_message "${string}"
  fi
}
