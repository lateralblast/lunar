#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_svcadm_service
#
# Function to audit a svcadm service and enable or disable
#
# service_name    = Name of service
# correct_status  = What the status of the service should be, ie enabled/disabled
#.

check_svcadm_service () {
  print_function "check_svcadm_service"
  if [ "${os_name}" = "SunOS" ]; then
    service_name="$1"
    correct_status="$2"
    file_header="svcadm"
    service_exists=$( svcs -a | grep "${service_name}" | awk '{print $3}' )
    if [ "${audit_mode}" = 2 ]; then
      restore_file="${restore_dir}/${file_header}.log"
      if [ -f "${restore_file}" ]; then
        restore_status=$( grep "^${service_name}" "${restore_file}" | cut -f2 -d"," )
        restore_test=$( echo "${restore_status}" | grep "[A-z]" )
        if [ -n "${restore_test}" ]; then
          if [ "${restore_status}" != "${service_status}" ]; then
            restore_status=$( echo "${restore_status}" | sed "s/online/enable/g" | sed "s/offline/disable/g" )
            restore_message="Service \"${service_name}\" to \"${restore_status}\""
            restore_command="svcadm ${restore_status} ${service_name} ; svcadm refresh ${service_name}"
            execute_restore "${restore_command}" "${restore_message}" "sudo"
          fi
        fi
      fi
    else
      if [ "${service_exists}" = "${service_name}" ]; then
        service_status=$( svcs -Ho state "${service_name}" )
        log_file="${file_header}.log"
        string="Service ${service_name} is ${correct_status}"
        verbose_message "${string}" "check"
        if [ "${ansible_mode}" = 1 ]; then
          echo ""
          echo "- name: Checking ${string}"
          echo "  service:"
          echo "    name: ${service_name}"
          echo "    enabled: ${service_status}"
          echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
        fi
        if [ "${service_status}" != "${correct_status}" ]; then
          increment_insecure "Service \"${service_name}\" is \"enabled\""
          update_log_file  "${log_file}" "${service_name},${service_status}"
          lockdown_message="Service \"${service_name}\" to \"${correct_status}\""
          lockdown_command="inetadm -d ${service_name} ; svcadm refresh ${service_name}"
          execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
        else
          increment_secure "Service \"${service_name}\" is already \"disabled\""
        fi
      fi
    fi
  fi
}
