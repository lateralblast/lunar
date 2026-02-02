#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_old_users
#
# Audit users to check for accounts that have not been logged into etc
#.

audit_old_users () {
  print_function "audit_old_users"
  string="Old Users"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    never_count=0
    if [ "${audit_mode}" = 2 ]; then
      restore_file "/etc/shadow" "${restore_dir}"
    else
      command="grep -v \"/usr/bin/false\" \"/etc/passwd\" | grep -Ev \"^halt|^shutdown|^root|^sync|/sbin/nologin\" | cut -f1 -d:"
      command_message "${command}"
      user_list=$( eval "${command}" )
      for user_name in ${user_list}; do
        if test -r "/etc/shadow"; then
          command="grep \"^${user_name}:\" \"/etc/shadow\" | cut -f2 -d: | grep -cEv \"\*|\!\!|NP|LK|UP\" | sed \"s/ //g\""
          command_message "${command}"
          shadow_check=$( eval "${command}" )
          if [ "$shadow_check" = "1" ]; then
            command="last \"${user_name}\" | awk '{print \$1}' | grep -c \"${user_name}\" | sed \"s/ //g\""
            command_message "${command}"
            login_check=$( eval "${command}" )
            if [ "$login_check" = "1" ]; then
              if [ "${audit_mode}" = 1 ]; then
                never_count=$((never_count+1))
                increment_insecure "User \"${user_name}\" has not logged in recently and their account is not locked"
                verbose_message    "passwd -l ${user_name}" "fix"
              fi
              if [ "${audit_mode}" = 0 ]; then
                backup_file     "/etc/shadow"
                verbose_message "User \"${user_name}\" to locked" "set"
                passwd -l "${user_name}"
              fi
            fi
          fi
        fi
      done
      if [ "${never_count}" = 0 ]; then
        if [ "${audit_mode}" = 1 ]; then
          increment_secure "There are no users who have never logged that do not have their account locked"
        fi
      fi
    fi
  else
    na_message "${string}"
  fi
}
