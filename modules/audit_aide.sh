#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_aide
#
# Check AIDE
#
# Refer to Section(s) 1.3.1-2          Page(s) 73-7        CIS Ubuntu LTS 16.04 Benchmark v2.0.0
# Refer to Section(s) 1.3.1-2          Page(s) 73-7        CIS Ubuntu LTS 18.04 Benchmark v2.1.0
# Refer to Section(s) 1.3.1-2          Page(s) 74-8        CIS Ubuntu LTS 20.04 Benchmark v1.0.0
# Refer to Section(s) 1.3.1-2,4.1.4.11 Page(s) 104-8,551-2 CIS Ubuntu LTS 22.04 Benchmark v1.0.0
# Refer to Section(s) 6.3.1-3          Page(s) 924-31      CIS Ubuntu LTS 24.04 Benchmark v1.0.0
#.

audit_aide () {
  if [ "${os_name}" = "Linux" ]; then
    verbose_message     "AIDE" "check"
    check_linux_package "install" "aide"
    check_linux_package "install" "aide-common"
    if [ -d "/etc/aide" ]; then
      check_file_value    "is" "/etc/aide/aide.conf"  "/sbin/auditctl"   "space" "p+i+n+u+g+s+b+acl+xattrs+sha512"   "hash"
      check_file_value    "is" "/etc/aide/aide.conf"  "/sbin/auditd"     "space" "p+i+n+u+g+s+b+acl+xattrs+sha512"   "hash"
      check_file_value    "is" "/etc/aide/aide.conf"  "/sbin/ausearch"   "space" "p+i+n+u+g+s+b+acl+xattrs+sha512"   "hash"
      check_file_value    "is" "/etc/aide/aide.conf"  "/sbin/aureport"   "space" "p+i+n+u+g+s+b+acl+xattrs+sha512"   "hash"
      check_file_value    "is" "/etc/aide/aide.conf"  "/sbin/autrace"    "space" "p+i+n+u+g+s+b+acl+xattrs+sha512"   "hash"
      check_file_value    "is" "/etc/aide/aide.conf"  "/sbin/augenrules" "space" "p+i+n+u+g+s+b+acl+xattrs+sha512"   "hash"
    fi
    if [ "${os_release}" -lt 24 ]; then
      check_append_file   "/etc/cron.d/aide" "0 5 * * * /usr/bin/aide.wrapper --config /etc/aide/aide.conf --check" "hash"
    else
      check_linux_service "dailyaidecheck.timer"      "on"
    fi
  fi
}
