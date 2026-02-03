#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_pmset
#
# Check Apple Power Management settings
#.

check_pmset() {
  print_function "check_pmset"
  if [ "${os_name}" = "Darwin" ]; then
    service="${1}"
    value="${2}"
    state="${value}"
    if [ "${value}" = "off" ]; then
      value="0"
    fi
    if [ "${value}" = "on" ]; then
      value="1"
    fi
    if [ "${value}" = "0" ]; then
      state="off"
    fi
    if [ "${value}" = "1" ]; then
      state="on"
    fi
    log_file="pmset_${service}.log"
    command="pmset -g | grep \"${service}\" | awk '{print \$2}' | grep -c \"${value}\" | sed \"s/ //g\""
    command_message "${command}"
    actual_test=$( eval "${command}" )
    if [ "$actual_test" = "0" ]; then
      actual_value="not-found"
    else
      command="pmset -g | grep \"${service}\" | awk '{print \$2}' | grep \"${value}\""
      command_message "${command}"
      actual_value=$( eval "${command}" )
    fi
    if [ "${audit_mode}" != 2 ]; then
      string="Sleep is disabled when powered"
      verbose_message "${string}" "check"
      if [ "${ansible_mode}" = 1 ]; then
        ansible_counter=$((ansible_counter+1))
        ansible_value="check_pmset_${ansible_counter}"
        echo ""
        echo "- name: Checking ${string}"
        echo "  command: sh -c \"pmset -g | grep ${service} |awk '{print \$2}' |grep ${value}\""
        echo "  register: ${ansible_value}"
        echo "  failed_when: ${ansible_value} == 1"
        echo "  changed_when: false"
        echo "  ignore_errors: true"
        echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
        echo "- name: Fixing ${string}"
        echo "  command: sh -c \"pmset -c ${service} ${value}\""
        echo "  when: ${ansible_value}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
      fi
      if [ ! "${actual_value}" = "${value}" ]; then
        increment_insecure "Service \"${service}\" is not \"${state}\""
        lockdown_command="echo \"${state}\" > ${work_dir}/${log_file} ; pmset -c ${service} ${value}"
        lockdown_message="Service \"${service}\" to \"${state}\""
        execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
      else
        increment_secure "Service \"${service}\" is \"${state}\""
      fi
    else
      restore_file=$retore_dir/${log_file}
      if [ -f "${restore_file}" ]; then
        restore_value=$( cat "${restore_file}" )
        if [ "${restore_value}" != "${actual_value}" ]; then
          restore_message="Wake on lan to enabled"
          restore_command="pmset -c ${service} ${restore_value}"
          execute_restore "${restore_command}" "${restore_message}" "sudo"
        fi
      fi
    fi
  fi
}
