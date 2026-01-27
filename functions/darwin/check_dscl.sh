#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_dscl
#
# Function to check dscl output under OS X
#.

check_dscl () {
  print_function "check_dscl"
  if [ "${os_name}" = "Darwin" ]; then
    file="${1}"
    param="${2}"
    value="${3}"
    dir="/var/db/dslocal/nodes/Default"
    if [ "${audit_mode}" != 2 ]; then
      string="Parameter \"${param}\" is set to \"${value}\" in \"${file}\""
      verbose_message "${string}" "check"
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
      d_check=$( sudo dscl . -read "${file}" "${param}" 2> /dev/null | wc -l | sed "s/ //g" )
      if [ "${d_check}" = "0" ]; then
        check="not-found"
      else
        check=$( sudo dscl . -read "${file}" "${param}" 2> /dev/null )
      fi
      if [ "${check}" != "${value}" ]; then
        increment_insecure "Parameter \"${param}\" not set to \"${value}\" in \"${file}\""
        verbose_message    "sudo dscl . -create ${file} ${param} \"${value}\"" "fix"
        if [ "${audit_mode}" = 0 ]; then
          backup_file      "${dir}/${file}"
          lockdown_message="Parameter \"${param}\" to \"${value}\" in ${file}"
          lockdown_message="dscl . -create ${file} ${param} ${value}"
          execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
        fi
      else
        if [ "${audit_mode}" = 1 ]; then
          increment_secure    "Parameter \"${param}\" is set to \"${value}\" in \"${file}\""
        fi
      fi
    else
      restore_file "${dir}/${file}" "${restore_dir}"
    fi
  fi
}
