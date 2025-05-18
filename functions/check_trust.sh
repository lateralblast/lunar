#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_trust
#
# Function to check trustchk under AIX
#.

check_trust() {
  print_function "check_trust"
  if [ "${os_name}" = "AIX" ]; then
    parameter_name="$1"
    correct_value="$2"
    log_file="trustchk_${parameter_name}.log"
    actual_value=$( trustchk -p "${parameter_name}" | cut -f2 -d= )
    policy_command="trustchk -p ${parameter_name} | cut -f2 -d= | grep ${correct_value}"
    lockdown_command="trustchk -p ${parameter_name}=${correct_value}"
    if [ "${audit_mode}" != 2 ]; then
      string="Trusted Execution setting for \"${parameter_name}\" is set to \"${correct_value}\""
      verbose_message "${string}" "check"
      if [ "${actual_value}" != "${correct_value}" ]; then
        increment_insecure "Trusted Execution setting for \"${parameter_name}\" is not set to \"${correct_value}\""
        update_log_file  "${log_file}" "trustchk-p ${parameter_name}=${actual_value}"
        lockdown_message="Trusted Execution setting for \"${parameter_name}\" to \"${correct_value}\""
        execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
      else
        increment_secure "Password Policy for \"${parameter_name}\" is set to \"${correct_value}\""
      fi
      if [ "${ansible}" = 1 ]; then
        ansible_counter=$((ansible_counter+1))
        ansible_value="check_trust_${ansible_counter}"
        echo ""
        echo "- name: Checking ${string}"
        echo "  command:  sh -c \"${policy_command}\""
        echo "  register: ${ansible_value}"
        echo "  failed_when: ${ansible_value} == 1"
        echo "  changed_when: false"
        echo "  ignore_errors: true"
        echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
        echo "- name: Fixing ${string}"
        echo "  command: sh -c \"${lockdown_command}\""
        echo "  when: ${ansible_value}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
      fi
    else
      log_file="${restore_dir}/${log_file}"
      if [ -f "${log_file}" ]; then
        previous_value=$( cut -f2 -d= "${log_file}" )
        if [ "${previous_value}" != "${actual_value}" ]; then
          restore_command="sh < ${log_file}"
          restore_message="Password Policy for \"${parameter_name}\" to \"${previous_value}\""
          execute_restore "${restore_command}" "${restore_message}" "sudo"
        fi
      fi
    fi
  fi
}
