#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_super_users
#
# Check Super Users
#
# Refer to Section(s) 9.2.5 Page(s) 190-1  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.5 Page(s) 165    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.5 Page(s) 168    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.2.5 Page(s) 278    CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 13.5  Page(s) 156-7  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.6   Page(s) 28     CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.2.8 Page(s) 32     CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9-5   Page(s) 75-6   CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.5   Page(s) 119-20 CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.5 Page(s) 256    CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 6.2.5 Page(s) 270    CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_super_users () {
  print_function "audit_super_users"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ] || [ "${os_name}" = "AIX" ]; then
    verbose_message "Accounts with UID 0" "check"
    if [ "${os_name}" = "AIX" ]; then
      check_chuser su true sugroups system root
    else
      if [ "${audit_mode}" != 2 ]; then
        lockdown_command="userdel ${user_name}"
        command="awk -F: '\$3 == \"0\" { print \$1 }' /etc/passwd | grep -v root"
        command_message "${command}"
        user_list=$( eval "${command}" )
        for user_name in ${user_list}; do
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "UID 0 for User \"${user_name}\""
            verbose_message    "${lockdown_command}"
          fi
          if [ "${audit_mode}" = 0 ]; then
            backup_file "/etc/shadow"
            backup_file "/etc/passwd"
            lockdown_message="Removing Account ${user_name} as it is UID 0"
            lockdown_command="userdel ${user_name}"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          fi
        done
        if [ "${user_name}" = "" ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_secure "No accounts other than root have UID 0"
          fi
        fi
      else
        restore_file "/etc/shadow" "${restore_dir}"
        restore_file "/etc/passwd" "${restore_dir}"
      fi
    fi
  fi
}
