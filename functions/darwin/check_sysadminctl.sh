#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_sysadminctl
#
# Function to check sysadminctl output under OS X
#.

check_sysadminctl () {
  print_function "check_sysadminctl"
  if [ "${os_name}" = "Darwin" ]; then
    param="${1}"
    value="${2}"
    log_file="sysadminctl.log"
    if [ "${value}" = "off" ]; then
      search_value="disabled"
      other_value="on"
    fi
    if [ "${value}" = "on" ]; then
      search_value="enabled"
      other_value="off"
    fi
    if [ "${audit_mode}" != 2 ]; then
      string="Parameter \"${param}\" is set to \"${value}\""
      verbose_message  "${string}" "check"
      get_command="sudo sysadminctl -${param} status > /dev/null 2>&1 |grep ${search_value}"
      set_command="sudo sysadminctl -${param} ${value}"
      if [ "${ansible_mode}" = 1 ]; then
        ansible_counter=$((ansible_counter+1))
        ansible_value="check_sysadminctl_${ansible_counter}"
        echo ""
        echo "- name: Checking ${string}"
        echo "  command: sh -c \"${get_command}\""
        echo "  register: ${ansible_value}"
        echo "  failed_when: \"${search_value}\" not in ${ansible_value}"
        echo "  changed_when: false"
        echo "  ignore_errors: true"
        echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
        echo "- name: Fixing ${string}"
        echo "  command: sh -c \"${set_command}\""
        echo "  when: ${ansible_value}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
      fi
      command="sudo sysadminctl -${param} status > /dev/null 2>&1 | grep ${search_value} | wc -l | sed 's/ //g'"
      command_message "${command}"
      check=$( eval "${command}" )
      if [ "${check}" != "1" ]; then
        increment_insecure "Parameter \"${param}\" not set to \"${value}\""
        verbose_message    "sudo sysadminctl -${param} ${value}" "fix"
        if [ "${audit_mode}" = 0 ]; then
          update_log_file  "${log_file}" "${param},${other_value}"
          lockdown_message="Parameter \"${param}\" to \"${value}\"" "set"
          lockdown_command="${set_command}"
          execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
        fi
      else
        if [ "${audit_mode}" = 1 ]; then
          increment_secure "Parameter \"${param}\" is set to \"${value}\""
        fi
      fi
    else
      restore_file="${restore_dir}/${log_file}"
      restore_value=$( grep "^${param}" "${restore_file}" |cut -f2 -d, )
      verbose_message "Parameter \"${param}\" to \"${restore_value}\"" "set"
      restore_command="sudo sysadminctl -${param} ${restore_value}"
      execute_restore "${restore_command}" "Restoring Parameter \"${param}\" to \"${restore_value}\"" "sudo"
    fi
  fi
}
