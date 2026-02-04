#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_user_rhosts
#
# Check for rhosts files
#
# Refer to Section(s) 9.2.10 Page(s) 169-70 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.10 Page(s) 195-6  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.10 Page(s) 172-3  CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.2.14 Page(s) 289    CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 13.10  Page(s) 161    CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.2    Page(s) 25     CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.5.1  Page(s) 101-2  CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.10   Page(s) 79     CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.10   Page(s) 124    CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.14 Page(s) 267-8  CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 6.2.14 Page(s) 281    CIS Ubuntu 16.04 Benchmark v2.0.0
# Refer to Section(s) 7.2.10 Page(s) 986-92 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_user_rhosts () {
  print_function "audit_user_rhosts"
  string="User RHosts Files"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ] || [ "${os_name}" = "AIX" ]; then
    check_fail=0
    command="grep -v '^/$' < /etc/passwd | cut -f6 -d':'"
    command_message "${command}"
    home_dirs=$( eval "${command}" )
    for home_dir in ${home_dirs}; do
      check_file="${home_dir}/.rhosts"
      if [ -f "${check_file}" ]; then
        check_fail=1
        check_file_exists "${check_file}" "no"
      fi
    done
    if [ "${check_fail}" != 1 ]; then
      if [ "${audit_mode}" = 1 ]; then
        increment_secure   "No user rhosts files exist"
      else
        increment_insecure "User rhosts files exist"
      fi
    fi
  else
    na_message "${string}"
  fi
}
