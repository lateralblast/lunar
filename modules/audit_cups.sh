#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_cups
#
# Check CUPS
#
# Refer to Section(s) 3.4     Page(s) 61    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.4     Page(s) 73-4  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.4     Page(s) 64    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.4   Page(s) 104   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 6.3     Page(s) 53-4  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.2.4   Page(s) 96    CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.3   Page(s) 104   CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 2.1.11  Page(s) 257-9 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_cups () {
  if [ "${os_name}" = "Linux" ]; then
    verbose_message "Printing Services" "check"
    for service_name in cups cups-lpd cupsrenice; do
      check_linux_service "${service_name}" "off"
    done
    check_file_perms "/etc/init.d/cups" "0744" "root" "root"
    check_file_perms "/etc/cups/client.conf" "0644" "root" "lp"
    check_file_perms "/etc/cups/cupsd.conf" "0600" "lp" "sys"
    check_file_value "is" "/etc/cups/cupsd.conf" "User"  "space" "lp"  "hash"
    check_file_value "is" "/etc/cups/cupsd.conf" "Group" "space" "sys" "hash"
  fi
}
