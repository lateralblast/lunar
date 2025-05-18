#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_osx_systemsetup
#
# Function to systemsetup output under OS X
#.

check_osx_systemsetup () {
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${os_version}" -ge 12 ]; then
      param="$1"
      value="$2"
      log_file="systemsetup_${param}.log"
      if [ "${audit_mode}" != 2 ]; then
        string="Parameter \"${param}\" is set to \"${value}\""
        verbose_message "${string}" "check"
        if [ "${ansible}" = 1 ]; then
          ansible_counter=$((ansible_counter+1))
          ansible_value="check_osx_systemsetup_${ansible_counter}"
          echo ""
          echo "- name: Checking ${string}"
          echo "  command: sh -c \"sudo systemsetup -${param} |cut -f2 -d: |sed 's/ //g' |tr '[:upper:]' '[:lower:]'\""
          echo "  register: ${ansible_value}"
          echo "  failed_when: ${ansible_value} == 1"
          echo "  changed_when: false"
          echo "  ignore_errors: true"
          echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
          echo "- name: Fixing ${string}"
          echo "  command: sudo systemsetup -${param} ${value}"
          echo "  when: ${ansible_value}.rc == 0 and ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
        fi
        check=$( eval "sudo systemsetup -${param} | cut -f2 -d: | sed 's/ //g' | tr '[:upper:]' '[:lower:]'" )
        if [ "${check}" != "${value}" ]; then
          increment_insecure "Parameter \"${param}\" not set to \"${value}\""
          update_log_file  "${log_file}" "${check_file}"
          lockdown_command="systemsetup -${param} ${value}"
          lockdown_message="Parameter \"${param}\" to \"${value}\""
          execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
        else
          increment_secure "Parameter \"${param}\" is set to \"${value}\""
        fi
      else
        restore_file="${restore_dir}/${log_file}"
        if [ -f "${restore_file}" ]; then
          now=$( eval "sudo systemsetup -${param} | cut -f2 -d: | sed 's/ //g' | tr '[:upper:]' '[:lower:]'" )
          old=$( cat "${restore_file}" )
          if [ "${now}" != "${old}" ]; then
            restore_command="systemsetup -${param} ${old}"
            restore_message="Parameter \"${param}\" back to \"${old}\"" "set"
            execute_restore "${restore_command}" "${restore_message}" "sudo"
          fi
        fi
      fi
    fi
  fi
}
