#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_wheel_users
#
# Check users in wheel group have recently logged in, if not lock them
#

audit_wheel_users () {
  print_function "audit_wheel_users"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "Darwin" ]; then
    verbose_message "Wheel Users" "check"
    check_file="/etc/group"
    if [ "${audit_mode}" != 2 ]; then
      command="grep \"^${wheel_group}:\" \"${check_file}\" | cut -f4 -d: | sed 's/,/ /g'"
      command_message "${command}"
      user_list=$( eval "${command}" )
      for user_name in ${user_list}; do
        command="last -1 "${user_name}" | grep '[a-z]' | awk '{print \$1}'"
        command_message "${command}"
        last_login=$( eval "${command}" )
        if [ "${last_login}" = "wtmp" ]; then
          command="read -r \"/etc/shadow\""
          command_message "${command}"
          if eval "${command}"; then
            command="grep \"^${user_name}:\" /etc/shadow | grep -v 'LK' | cut -f1 -d:"
            command_message "${command}"
            lock_test=$( eval "${command}" )
            if [ "${lock_test}" = "${user_name}" ]; then
              if [ "${ansible_mode}" = 1 ]; then
                echo ""
                echo "- name: Checking password lock for ${user_name}"
                echo "  user:"
                echo "    name: ${user_name}"
                echo "    password_lock: yes"
                echo ""
              fi
              if [ "${audit_mode}" = 1 ]; then
                increment_insecure "User ${user_name} has not logged in recently and their account is not locked"
              fi
              if [ "${audit_mode}" = 0 ]; then
                backup_file      "${check_file}"
                lockdown_message "User \"${user_name}\" to locked"
                lockdown_command="passwd -l ${user_name}"
                execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
              fi
            fi
          fi
        fi
      done
    else
      restore_file "${check_file}" "${restore_dir}"
    fi
  fi
}
