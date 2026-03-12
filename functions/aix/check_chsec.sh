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
    sec_file="${1}"
    sec_stanza="${2}"
    parameter_name="${3}"
    correct_value="${4}"
    print_function "check_chsec"
    log_file="${sec_file}_${sec_stanza}_${parameter_name}.log"
    get_command="lssec -f ${sec_file} -s ${sec_stanza} -a ${parameter_name} |awk '{print \$2}' |cut -f2 -d="
    set_command="chsec -f ${sec_file} -s ${sec_stanza} -a ${parameter_name}=${correct_value}"
    if [ "${audit_mode}" != 2 ]; then
      string="Security Policy for \"${parameter_name}\" is set to \"${correct_value}\""
      check_message  "${string}"
      if [ "${ansible_mode}" = 1 ]; then
        ansible_counter=$((ansible_counter+1))
        ansible_value="check_chsec_${ansible_counter}"
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
      actual_value=$( eval "${get_command}" )
      if [ "${actual_value}" != "${correct_value}" ]; then
        update_log   "${log_file}" "chsec -f ${sec_file} -s ${sec_stanza} -a ${parameter_name}=${actual_value}"
        inc_insecure "Security Policy for \"${parameter_name}\" is not set to \"${correct_value}\""
        lock_command="chsec -f ${sec_file} -s ${sec_stanza} -a ${parameter_name}=${correct_value}"
        lock_message="Security Policy for \"${parameter_name}\" to \"${correct_value}\""
        run_lockdown "${lock_command}" "${lock_message}" "sudo"
      else
        inc_secure   "Password Policy for \"${parameter_name}\" is set to \"${correct_value}\""
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
