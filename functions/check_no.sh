#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_no
#
# Function to check no under AIX
#.

check_no() {
  print_function "check_no"
  if [ "${os_name}" = "AIX" ]; then
    parameter_name="$1"
    correct_value="$2"
    log_file="${parameter_name}.log"
    get_command="no -a |grep '${parameter_name} ' |cut -f2 -d= |sed 's/ //g' |grep '${correct_value}'"
    set_command="no -p -o ${parameter_name}=${correct_value}"
    actual_value=$( eval "${get_command}" )
    if [ "${audit_mode}" != 2 ]; then
      string="Parameter \"${parameter_name}\" is \"${correct_value}\""
      verbose_message "${string}" "check"
      if [ "${ansible}" = 1 ]; then
        ansible_counter=$((ansible_counter+1))
        ansible_value="check_no_${ansible_counter}"
        echo ""
        echo "- name: Checking ${string}"
        echo "  command: sh -c \"${get_command}\""
        echo "  register: ${ansible_value}"
        echo "  failed_when: ${ansible_value} == 1"
        echo "  changed_when: false"
        echo "  ignore_errors: true"
        echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
        echo "- name: Fixing ${string}"
        echo "  command: sh -c \"${set_command}\""
        echo "  when: ${ansible_value}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
      fi
      if [ "${actual_value}" != "${correct_value}" ]; then
        increment_insecure "Parameter \"${parameter_name}\" is not \"${correct_value}\""
        update_log_file  "${log_file}" "${actual_value}"
        lockdown_command="no -p -o ${parameter_name}=${correct_value}"
        lockdown_message="Parameter \"${parameter_name}\" to \"${correct_value}\""
        execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
      else
        increment_secure "Parameter \"${parameter_name}\" is \"${correct_value}\""
      fi
    else
      log_file="${restore_dir}/${log_file}"
      if [ -f "${log_file}" ]; then
        previous_value=$( cat "${log_file}" )
        if [ "${previous_value}" != "${actual_value}" ]; then
          restore_message="Parameter \"${parameter_name}\" to \"${previous_value}\""
          restore_command="no -p -o ${parameter_name}=${previous_value}"
          execute_restore "${restore_command}" "${restore_message}" "sudo"
        fi
      fi
    fi
  fi
}
