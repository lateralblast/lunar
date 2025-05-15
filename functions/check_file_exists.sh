#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_file_exists
#
# Check to see a file ${exists} and create it or delete it
#
# check_file    = File to check fo
# check_${exists}  = If equal to no and file ${exists}, delete it
#                 If equal to yes and file doesn't exist, create it
#.

check_file_exists () {
  check_file="$1"
  check_exists="$2"
  log_file="file.log"
  ansible_counter=$((ansible_counter+1))
  ansible_value="check_file_exists_${ansible_counter}"
  if [ "${check_exists}" = "no" ]; then
    if [ "${audit_mode}" != 2 ]; then
      string="File \"${check_file}\" does not exist"
      verbose_message "${string}" "check"
      if [ "${ansible}" = 1 ]; then
        echo ""
        echo "- name: Checking ${string}"
        echo "  stat:"
        echo "    path ${check_file}"
        echo "  register: ${ansible_value}"
        echo ""
        echo "- name: Fixing ${string}"
        echo "  file:"
        echo "    path: ${check_file}"
        echo "    state: absent"
        echo "  when: ${ansible_value}.${exists} == True"
        echo ""
      fi
    fi
    if [ -f "${check_file}" ]; then
      if [ "${audit_mode}" = 1 ]; then
        increment_insecure "File \"${check_file}\" ${exists}"
      fi
      if [ "${audit_mode}" = 0 ]; then
        backup_file      "${check_file}"
        update_log_file  "${log_file}" "${check_file},rm"
        lockdown_message="File \"${check_file}\""
        lockdown_command="rm ${check_file}"
        execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
      fi
    else
      if [ "${audit_mode}" = 1 ]; then
        increment_secure "File \"${check_file}\" does not exist"
      fi
    fi
  else
    if [ "${audit_mode}" != 2 ]; then
      string="File \"${check_file}\" ${exists}"
      verbose_message "${string}" "check"
      if [ "${ansible}" = 1 ]; then
        echo ""
        echo "- name: Checking ${string}"
        echo "  stat:"
        echo "    path ${check_file}"
        echo "  register: stat_result"
        echo ""
        echo "- name: Fixing ${string}"
        echo "  file:"
        echo "    path: ${check_file}"
        echo "    state: touch"
        echo "  when: stat_result.${exists} == False"
        echo ""
      fi
    fi
    if [ ! -f "${check_file}" ]; then
      if [ "${audit_mode}" = 1 ]; then
        increment_insecure "File \"${check_file}\" does not exist"
      fi
      if [ "${audit_mode}" = 0 ]; then
        update_log_file  "${log_file}" "${check_file},touch"
        lockdown_message="File \"${check_file}\""
        lockdown_command="touch ${check_file}"
        execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
      fi
    else
      if [ "${audit_mode}" = 1 ]; then
        increment_secure "File \"${check_file}\" ${exists}"
      fi
    fi
  fi
  if [ "${audit_mode}" = 2 ]; then
    restore_file "${check_file}" "${restore_dir}"
  fi
}
