#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_duplicate_users
#
# Check duplicate users
#
# Refer to Section(s) 9.2.16,17 Page(s) 174-5       CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.15,18 Page(s) 201,203-4   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.16,17 Page(s) 177-8       CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.2.16,18 Page(s) 291,3       CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 13.14,16  Page(s) 164-5       CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.12.16   Page(s) 219         CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.15,18   Page(s) 82-3,5      CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.15,18   Page(s) 128-9,131   CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.16,18 Page(s) 269,71      CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 6.2.16,18 Page(s) 283,5       CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 7.2.5,7   Page(s) 977-8,974-5 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_duplicate_users () {
  print_module "audit_duplicate_users"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "AIX" ]; then
    verbose_message     "Duplicate Users"  "check"
    audit_duplicate_ids "1" "users" "name" "/etc/passwd"
    audit_duplicate_ids "3" "users" "id"   "/etc/passwd"
  fi
}
