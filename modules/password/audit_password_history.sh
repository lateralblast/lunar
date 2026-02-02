#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154


# audit_password_history
#
# Refer to Section(s) 5.4.1.6 Page(s) 692-3 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_password_history () {
  print_function "audit_password_history"
  if [ "${os_name}" = "Linux" ]; then
    verbose_message "Password History" "check"
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    if [ "${audit_mode}" != 2 ]; then
      check_file="/etc/shadow"
      current_date=$( date +%s )
      command="awk -F: '\$2~/^\$.+\$/{print \$1}' \"${check_file}\""
      command_message "${command}"
      user_list=$( eval "${command}" )
      for user_name in ${user_list}; do
        command="date -d \"\$(chage --list \"${user_name}\" | grep '^Last password change' | cut -d: -f2 | grep -v 'never\$')\" +%s"
        command_message "${command}"
        change_date=$( eval "${command}" )
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
