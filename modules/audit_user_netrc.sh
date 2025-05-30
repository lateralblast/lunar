#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_user_netrc
#
# Check for netrc files
#
# Refer to Section(s) 9.2.9    Page(s) 168-169     CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.9,20 Page(s) 194-5,205-6 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.9    Page(s) 171-2       CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.2.13-4 Page(s) 286-8       CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 13.9,18  Page(s) 160-1,167   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.2.13-4 Page(s) 265-7       CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 7.2      Page(s) 25          CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.5.1    Page(s) 101-2       CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.9,20   Page(s) 78-9,86     CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.9,20   Page(s) 122-3,132-3 CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 7.2.10   Page(s) 986-92      CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_user_netrc () {
  print_function "audit_user_netrc"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ] || [ "${os_name}" = "AIX" ]; then
    verbose_message "User Netrc Files" "check"
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    check_fail=0
    home_dirs=$( grep -v "^/$" < /etc/passwd | cut -f6 -d":" )
    for home_dir in ${home_dirs}; do
      check_file="${home_dir}/.netrc"
      if [ -f "${check_file}" ]; then
        check_fail=1
        check_file_perms "${check_file}" "0600"
      fi
    done
    if [ "${check_fail}" != 1 ]; then
      if [ "${audit_mode}" = 1 ]; then
        increment_secure   "No user netrc files exist"
      else
        increment_insecure "User netrc files exist"
      fi
    fi
  fi
}
