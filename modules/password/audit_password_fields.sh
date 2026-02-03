#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154


# audit_password_fields
#
# Ensure Password Fields are Not Empty
# Verify System Account Default Passwords
# Ensure Password Fields are Not Empty
#
# Refer to Section(s) 9.2.1           Page(s) 162-3       CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.1           Page(s) 187-8       CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.1           Page(s) 166         CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.2.1           Page(s) 274         CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 13.1            Page(s) 154         CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.2             Page(s) 27          CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.2.15          Page(s) 219         CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.4             Page(s) 75          CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.3             Page(s) 118         CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.1           Page(s) 252         CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 6.2.1-4         Page(s) 266-9       CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 5.4.2.1,7.2.1-2 Page(s) 695-7,965-9 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_password_fields () {
  print_function "audit_password_fields"
  string="Password Fields"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ] || [ "${os_name}" = "AIX" ]; then
    if [ "${audit_mode}" != 2 ]; then
      check_file="/etc/passwd"
      command="awk -F: '(\$3 == 0) { print \$1 }' \"${check_file}\" | grep -v root"
      command_message "${command}"
      user_list=$( eval "${command}" )
      if [ "$user_list" = "" ]; then
        increment_secure "No non root users have UID 0"
      else
        for user_name in ${user_list}; do
          if [ "${user_name}" != "root" ]; then
            increment_insecure "Non root user ${user_name} has UID 0"
          fi
        done
      fi
    else
      check_file="/etc/passwd"
      restore_file "${check_file}" "${restore_dir}"
    fi
    verbose_message "Shadow Fields" "check"
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    if [ "${audit_mode}" != 2 ]; then
      check_file="/etc/shadow"
      empty_count=0
      if [ "${os_name}" = "AIX" ]; then
        command="pwdck –n ALL"
        command_message "${command}"
        user_list=$( eval "${command}" )
      else
        command="awk -F':' '{ print \$1\":\"\$2\":\" }' < /etc/shadow | grep \"::$\" | cut -f1 -d:"
        command_message "${command}"
        user_list=$( eval "${command}" )
      fi
      for user_name in ${user_list}; do
        empty_count=1
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure "No password field for \"${user_name}\" in \"${check_file}\""
          verbose_message    "passwd -d ${user_name}" "fix"
          if [ "${os_name}" = "SunOS" ]; then
            verbose_message  "passwd -N ${user_name}" "fix"
          fi
        fi
        if [ "${audit_mode}" = 0 ]; then
          backup_file     "${check_file}"
          verbose_message "No password for \"${user_name}\"" "set"
          passwd -d "${user_name}"
          if [ "${os_name}" = "SunOS" ]; then
            passwd -N "${user_name}"
          fi
        fi
      done
      if [ "$empty_count" = 0 ]; then
        increment_secure "No empty password entries"
      fi
      for check_file in /etc/passwd /etc/shadow; do
        if test -r "${check_file}"; then
          command="grep '^+:' ${check_file} | head -1 | wc -l | sed \"s/ //g\""
          command_message "${command}"
          legacy_check=$( eval "${command}" )
          if [ "${legacy_check}" != "0" ]; then
            if [ "${audit_mode}" = 1 ]; then
              increment_insecure "Legacy field found in \"${check_file}\""
              verbose_message    "grep -v '^+:' : ${check_file} > ${temp_file}" fix
              verbose_message    "cat ${temp_file}  > ${check_file}" fix
            fi
            if [ "${audit_mode}" = 0 ]; then
              backup_file     "${check_file}"
              verbose_message "Legacy entries from \"${check_file}\"" "remove"
              command="grep -v \"^+:\" \"${check_file}\" > \"${temp_file}\""
              command_message "${command}"
              eval "${command}"
              command="cat \"${temp_file}\"  > \"${check_file}\""
              command_message "${command}"
              eval "${command}"
            fi
          else
            increment_secure "No legacy entries in \"${check_file}\""
          fi
        fi
      done
    else
      check_file="/etc/shadow"
      restore_file "${check_file}" "${restore_dir}"
    fi
  else
    na_message "${string}"
  fi
}
