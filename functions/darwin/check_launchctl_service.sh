#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_launchctl_service
#
# Function to check launchctl output under OS X
#.

check_launchctl_service () {
  print_function "check_launchctl_service"
  if [ "${os_name}" = "Darwin" ]; then
    launchctl_service="$1"
    required_status="$2"
    log_file="${launchctl_service}.log"
    if [ "${required_status}" = "on" ] || [ "${required_status}" = "enable" ]; then
      required_status="enabled"
      change_status="load"
    else
      required_status="disabled"
      change_status="unload"
    fi
    get_command="launchctl list |grep ${launchctl_service} |awk '{print \$3}'"
    set_command="sudo launchctl ${change_status} -w ${launchctl_service}.plist"
    check_value=$( eval "${get_command}" )
    if [ "${check_value}" = "${launchctl_service}" ]; then
      actual_status="enabled"
    else
      actual_status="disabled"
    fi
    if [ "${audit_mode}" != 2 ]; then
      string="Service \"${launchctl_service}\" is \"${required_status}\""
      verbose_message "${string}" "check"
      if [ "${ansible_mode}" = 1 ]; then
        ansible_counter=$((ansible_counter+1))
        ansible_value="check_launchctl_service_${ansible_counter}"
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
      if [ "${actual_status}" != "${required_status}" ]; then
        increment_insecure "Service \"${launchctl_service}\" is \"${actual_status}\""
        lockdown_command="sudo launchctl ${change_status} -w ${launchctl_service}.plist"
        lockdown_message="Service ${launchctl_service} to ${required_status}"
        update_log_file  "${log_file}" "${actual_status}"
        execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
      else
        increment_secure "Service \"${launchctl_service}\" is \"${required_status}\""
      fi
    else
      log_file="${restore_dir}/${log_file}"
      if [ -f "${log_file}" ]; then
        restore_status=$( cat "${log_file}" )
        if [ "${restore_status}" = "enabled" ]; then
          change_status="load"
        else
          change_status="unload"
        fi
        if [ "${restore_status}" != "${actual_status}" ]; then
          restore_message="Restoring ${launchctl_service} to ${change_status}"
          restore_command="launchctl ${change_status} -w ${launchctl_service}.plist"
          execute_restore "${restore_command}" "${restore_message}" "sudo"
        fi
      fi
    fi
  fi
}
