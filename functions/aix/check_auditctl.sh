#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_auditctl
#
# Check whether a executable, file or directory is being audited
#.

check_auditctl () {
  print_function "check_auditctl"
  check_file="${1}"
  audit_tag="${2}"
  if [ "${os_name}" = "Linux" ]; then
    if [ "${audit_mode}" != 2 ]; then
      secure_string="Auditing is enabled on file \"${check_file}\""
      insecure_string="Auditing is not enabled on file \"${check_file}\""
      verbose_message "${secure_string}" "check"
      get_command="auditctl -l | grep ${check_file}"
      set_command="auditctl -w ${file} -p wa -k ${audit_tag}"
      if [ -e "${check_file}" ]; then
        check=$( auditctl -l | grep "${check_file}" )
        if [ ! "${check}" ]; then
          if [ "${ansible_mode}" = 1 ]; then
            ansible_counter=$((ansible_counter+1))
            ansible_value="auditctl_file_check_${ansible_counter}"
            echo ""
            echo "- name: Checking ${secure_string}"
            echo "  command: sh -c \"${get_command}\""
            echo "  register: ${ansible_value}"
            echo "  failed_when: ${ansible_value} == 1"
            echo "  changed_when: false"
            echo "  ignore_errors: true"
            echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
            echo ""
            echo "- name: Enable Auditing for ${file}"
            echo "  command: sh -c \"${set_command}\""
            echo "  when: ${ansible_value}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
            echo ""
          fi
          increment_insecure "${insecure_string}"
          lockdown_command="${set_command}"
          lockdown_message="${secure_string}" 
          execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
        else
          increment_secure "${secure_string}"
        fi
      fi
    fi
  fi
}
