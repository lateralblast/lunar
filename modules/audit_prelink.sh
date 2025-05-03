#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_prelink
#
# Check prelinking
#
# Refer to Section(s) 1.3.1-2       Page(s) 34-5    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.3.1-2       Page(s) 39-40   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.3.1-2       Page(s) 36-7    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 1.3.1-2,1.5.4 Page(s) 54-6,66 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 1.3.1-2       Page(s) 49-52   CIS Ubuntu LTS 16.04 Benchmark v1.0.0
# Refer to Section(s) 1.5.2         Page(s) 122-3   CIS Ubuntu LTS 22.04 Benchmark v1.0.0
# Refer to Section(s) 1.5.4         Page(s) 179-80  CIS Ubuntu LTS 24.04 Benchmark v1.0.0
# Refer to Section(s) 8.3.1-2       Page(s) 112-3   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.3.1-2       Page(s) 47-9    CIS Amazon Linux Benchmark v2.0.0
#.

audit_prelink () {
  if [ "${os_name}" = "Linux" ]; then
    verbose_message "Prelinking" "check"
    if [ "${os_vendor}" = "CentOS" ] || [ "${os_vendor}" = "Red" ] || [ "${os_vendor}" = "Amazon" ]; then
      check_file="/etc/sysconfig/prelink"
    else
      check_file="/etc/default/prelink"
    fi
    if [ -f "${check_file}" ]; then
      prelink_check=$( grep PRELINKING "${check_file}" | cut -f2 -d= | sed 's/ //g' )
    else
      prelink_check="no"
    fi
    if [ "${prelink_check}" = "yes" ]; then
      lockdown_command  "prelink -ua" "Prelink to disabled"
    fi
    check_linux_package "uninstall"   "prelink"
  fi
}
