#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_telnet_client
#
# If telnet is not installed
#
# Refer to Section(s) 2.1.2 Page(s) 49    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.2 Page(s) 56    CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.2 Page(s) 51    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.3.4 Page(s) 127   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 2.3.4 Page(s) 114   CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.3.4 Page(s) 123   CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 2.2.4 Page(s) 298-9 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_telnet_client () {
  print_function "audit_telnet_client"
  if [ "${os_name}" = "Linux" ]; then
    verbose_message     "Telnet Client" "check"
    check_linux_package "uninstall"     "telnet"
    check_linux_package "uninstall"     "inetutils-telnet"
  fi
}
