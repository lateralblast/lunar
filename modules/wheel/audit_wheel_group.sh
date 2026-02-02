#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_wheel_group
#
# Make sure there is a wheel group so privileged account access is limited.
#.

audit_wheel_group () {
  print_function "audit_wheel_group"
  string="Wheel Group"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    check_file="/etc/group"
    if [ "${audit_mode}" != 2 ]; then
      command="grep \"^${wheel_group}:\" \"${check_file}\" |wc -c"
      command_message "${command}"
      check_value=$( eval "${command}" )
      if [ "${check_value}" = "0" ]; then
        if [ "${audit_mode}" = "1" ]; then
          increment_insecure "Wheel group \"${wheel_group}\" does not exist in \"${check_file}\""
        fi
        if [ "${ansible_mode}" = 1 ]; then
          echo ""
          echo "- name: Checking ${string}"
          echo "  group:"
          echo "    name: ${wheel_group}"
          echo "  when: ansible_facts['ansible_system'] == '${os_name}' or ansible_facts['ansible_system'] == '${os_name}'"
        fi
        if [ "${audit_mode}" = 0 ]; then
          backup_file     "${check_file}"
          lockdown_message="Adding wheel group \"${wheel_group}\" to \"${check_file}\""
          lockdown_command="groupadd ${wheel_group} ; usermod -G ${wheel_group} root"
          execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
        fi
      else
        if [ "${audit_mode}" = "1" ]; then
          increment_secure "Wheel group \"${wheel_group}\" ${exists} in \"${check_file}\""
        fi
      fi
    else
      restore_file "${check_file}" "${restore_dir}"
    fi
  else
    na_message "${string}"
  fi
}
