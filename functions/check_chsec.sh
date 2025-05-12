#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_chsec
#
# Function to check sec under AIX
#.

check_chsec() {
  if [ "${os_name}" = "AIX" ]; then
    sec_file="$1"
    sec_stanza="$2"
    parameter_name="$3"
    correct_value="$4"
    ansible_counter=$((ansible_counter+1))
    name="check_chsec_${ansible_counter}"
    log_file="${sec_file}_${sec_stanza}_${parameter_name}.log"
    get_command="lssec -f ${sec_file} -s ${sec_stanza} -a ${parameter_name} |awk '{print \$2}' |cut -f2 -d="
    set_command="chsec -f ${sec_file} -s ${sec_stanza} -a ${parameter_name}=${correct_value}"
    if [ "${audit_mode}" != 2 ]; then
      string="Security Policy for \"${parameter_name}\" is set to \"${correct_value}\""
      verbose_message "${string}" "check"
      if [ "${ansible}" = 1 ]; then
        echo ""
        echo "- name: Checking ${string}"
        echo "  command: sh -c \"${get_command}\""
        echo "  register: ${name}"
        echo "  failed_when: ${name} == 1"
        echo "  changed_when: false"
        echo "  ignore_errors: true"
        echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
        echo "- name: Fixing ${string}"
        echo "  command: sh -c \"${set_command}\""
        echo "  when: ${name}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
      fi
      actual_value=$( eval "${get_command}" )
      if [ "${actual_value}" != "${correct_value}" ]; then
        update_log_file "${log_file}" "chsec -f ${sec_file} -s ${sec_stanza} -a ${parameter_name}=${actual_value}"
        increment_insecure "Security Policy for \"${parameter_name}\" is not set to \"${correct_value}\""
        lockdown_command="chsec -f ${sec_file} -s ${sec_stanza} -a ${parameter_name}=${correct_value}"
        lockdown_message="Security Policy for \"${parameter_name}\" to \"${correct_value}\""
        execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
      else
        increment_secure   "Password Policy for \"${parameter_name}\" is set to \"${correct_value}\""
      fi
    else
      log_file="${restore_dir}/${log_file}"
      if [ -f "${log_file}" ]; then
        previous_value=$( cut -f2 -d= "${log_file}" )
        if [ "${previous_value}" != "${actual_value}" ]; then
          restore_message="Restoring: Password Policy for \"${parameter_name}\" to \"${previous_value}\""
          restore_command="sh < ${log_file}"
          execute_restore "${restore_command}" "${restore_message}" "sudo"
        fi
      fi
    fi
  fi
}
