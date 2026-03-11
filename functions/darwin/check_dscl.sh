#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_dscl
#
# Function to check dscl output under OS X
#.

check_dscl () {
  if [ "${os_name}" = "Darwin" ]; then
    file="${1}"
    param="${2}"
    value="${3}"
    print_function "check_dscl"
    dir="/var/db/dslocal/nodes/Default"
    if [ "${audit_mode}" != 2 ]; then
      string="Parameter \"${param}\" is set to \"${value}\" in \"${file}\""
      check_message "${string}"
      if [ "${ansible_mode}" = 1 ]; then
        ansible_counter=$((ansible_counter+1))
        ansible_value="check_dscl_${ansible_counter}"
        echo ""
        echo "- name: Checking ${string}"
        echo "  command: sh -c \"sudo dscl . -read ${file} ${param} 2> /dev/null\""
        echo "  register: ${ansible_value}"
        echo "  failed_when: ${ansible_value} == 1"
        echo "  changed_when: false"
        echo "  ignore_errors: true"
        echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
        echo "- name: Fixing ${string}"
        echo "  command: sh -c \"sudo dscl . -create ${file} ${param} '${value}'\""
        echo "  when: ${ansible_value}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
      fi
      command="sudo dscl . -read \"${file}\" \"${param}\" 2> /dev/null | wc -l | sed \"s/ //g\""
      command_message "${command}"
      d_check=$( eval "${command}" )
      if [ "${d_check}" = "0" ]; then
        check="not-found"
      else
        command="sudo dscl . -read \"${file}\" \"${param}\" 2> /dev/null"
        command_message "${command}"
        check=$( eval   "${command}" )
      fi
      if [ "${check}" != "${value}" ]; then
        inc_insecure "Parameter \"${param}\" not set to \"${value}\" in \"${file}\""
        fix_message  "sudo dscl . -create ${file} ${param} \"${value}\""
        if [ "${audit_mode}" = 0 ]; then
          backup_file      "${dir}/${file}"
          lockdown_message="Parameter \"${param}\" to \"${value}\" in ${file}"
          lockdown_command="dscl . -create ${file} ${param} ${value}"
          exec_lockdown    "${lockdown_command}" "${lockdown_message}" "sudo"
        fi
      else
        if [ "${audit_mode}" = 1 ]; then
          inc_secure "Parameter \"${param}\" is set to \"${value}\" in \"${file}\""
        fi
      fi
    else
      restore_file   "${dir}/${file}" "${restore_dir}"
    fi
  fi
}
