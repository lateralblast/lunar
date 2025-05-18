#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_pwpolicy
#
# Function to check pwpolicy output under OS X
#.

check_pwpolicy() {
  if [ "${os_name}" = "Darwin" ]; then
    parameter_name="$1"
    correct_value="$2"
    log_file="${parameter_name}.log"
    if [ "${audit_mode}" != 2 ]; then
      string="Password Policy for \"${parameter_name}\" is set to \"${correct_value}\""
      verbose_message "${string}" "check"
      if [ "${os_version}" -ge 12 ]; then
        policy_command="pwpolicy -getglobalpolicy |tr ' ' '\\\n' |grep ${parameter_name} |cut -f2 -d="
      else
        if [ "${managed_node}" = "Error" ]; then
          policy_command="sudo pwpolicy -n /Local/Default -getglobalpolicy ${parameter_name} 2>&1 |cut -f2 -d="
        else
          policy_command="sudo pwpolicy -n -getglobalpolicy ${parameter_name} 2>&1 |cut -f2 -d="
        fi
      fi
      actual_value=$( eval "${policy_command}" )
      if [ "${actual_value}" != "${correct_value}" ]; then
        lockdown_message="Password Policy for \"${parameter_name}\" to \"${correct_value}\""
        increment_insecure "Password Policy for \"${parameter_name}\" is not set to \"${correct_value}\""
        if [ "${os_version}" -ge 12 ]; then
          lockdown_command="sudo pwpolicy -setglobalpolicy ${parameter_name}=${correct_value}"
          update_log_file  "${log_file}" "${actual_value}"
          execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
        else
          if [ "${managed_node}" = "Error" ]; then
            lockdown_command="pwpolicy -n /Local/Default -setglobalpolicy ${parameter_name}=${correct_value}"
            update_log_file  "${log_file}" "${actual_value}"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          else
            lockdown_command="pwpolicy -n -setglobalpolicy ${parameter_name}=${correct_value}"
            update_log_file  "${log_file}" "${actual_value}"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          fi
        fi
        if [ "${ansible}" = 1 ]; then
          ansible_counter=$((ansible_counter+1))
          ansible_value="check_pwpolicy_${ansible_counter}"
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
        if [ "${audit_mode}" = 1 ]; then
          increment_secure "Password Policy for \"${parameter_name}\" is set to \"${correct_value}\""
        fi
      fi
    else
      log_file="${restore_dir}/${log_file}"
      if [ -f "${log_file}" ]; then
        previous_value=$( cat "${log_file}" )
        restore_message="Password Policy for \"${parameter_name}\" to \"${previous_value}\""
        if [ "${previous_value}" != "${actual_value}" ]; then
          if [ "${os_version}" -ge 12 ]; then
            restore_command="pwpolicy -setglobalpolicy ${parameter_name}=${previous_value}"
            execute_restore "${restore_command}" "${restore_message}" "sudo"
          else
            if [ "${managed_node}" = "Error" ]; then
              restore_command="pwpolicy -n /Local/Default -setglobalpolicy ${parameter_name}=${previous_value}"
              execute_restore "${restore_command}" "${restore_message}" "sudo"
            else
              restore_command="pwpolicy -n -setglobalpolicy ${parameter_name}=${previous_value}"
              execute_restore "${restore_command}" "${restore_message}" "sudo"
            fi
          fi
        fi
      fi
    fi
  fi
}
