#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154


# audit_password_history
#
# Refer to Section(s) 5.4.1.6 Page(s) 692-3 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_password_history () {
  if [ "${os_name}" = "Linux" ]; then
    verbose_message "Password History" "check"
    if [ "${audit_mode}" != 2 ]; then
      check_file="/etc/shadow"
      current_date=$( date +%s )
      user_list=$( awk -F: '$2~/^\$.+\$/{print $1}' "${check_file}" )
      for user_name in ${user_list}; do
        change_date=$( date -d "$(chage --list ${user_name} | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s )
        if [ "${change_date}" -gt "${current_date}" ]; then
          increment_insecure "User ${user_name} has a last password change date in the future"
        else
          increment_secure   "User ${user_name} has a last password change date in the past"
        fi
      done
    else
      for check_file in /etc/passwd /etc/shadow; do
        restore_file "${check_file}" "${restore_dir}"
      done
    fi
  fi
}
