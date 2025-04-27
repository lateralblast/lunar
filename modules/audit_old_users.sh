#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_old_users
#
# Audit users to check for accounts that have not been logged into etc
#.

audit_old_users () {
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    verbose_message "Old users" "check"
    never_count=0
    if [ "${audit_mode}" = 2 ]; then
      restore_file "/etc/shadow" "${restore_dir}"
    else
      user_list=$( grep -v "/usr/bin/false" "/etc/passwd" | grep -Ev "^halt|^shutdown|^root|^sync|/sbin/nologin" | cut -f1 -d: )
      for user_name in ${user_list}; do
        if test -r "/etc/shadow"; then
          shadow_check=$( grep "^${user_name}:" "/etc/shadow" | cut -f2 -d":" | grep -cEv "\*|\!\!|NP|LK|UP" | sed "s/ //g" )
          if [ "$shadow_check" = "1" ]; then
            login_check=$( last "${user_name}" | awk '{print $1}' | grep -c "${user_name}" | sed "s/ //g" )
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
  fi
}
