#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_subserver
#
# Function to check subserver under AIX
#.

check_subserver() {
  print_function "check_subserver"
  if [ "${os_name}" = "AIX" ]; then
    service_name="$1"
    protocol_name="$2"
    correct_value="$3"
    log_file="${service_name}.log"
    actual_value=$( grep "${service_name} " /etc/inetd.conf | grep "${protocol_name} " | grep -v "^#" | awk "{print $1}" )
    if [ "${actual_value}" != "${service_name}" ]; then
      actual_value="off"
    else
      actual_value="on"
    fi
    if [ "${audit_mode}" != 2 ]; then
      string="Service \"${service_name}\" Protocol \"${protocol_name}\" is \"${correct_value}\""
      verbose_message "${string}" "check"
      if [ "${ansible}" = 1 ]; then
        echo ""
        echo "- name: Checking ${string}"
        echo "  service:"
        echo "    name: ${service_name}"
        echo "    enabled: ${enabled}"
        echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
        echo ""
      fi
      if [ "${actual_value}" != "${service_name}" ]; then
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure "Service \"${service_name}\" Protocol \"${protocol_name}\" is not \"${correct_value}\""
          if [ "${correct_value}" = "off" ]; then
            fix_command="chsubserver -r inetd -C /etc/inetd.conf -d -v \"${service_name}\" -p \"${protocol_name}\""
            verbose_message "${fix_command}" "fix"
          else
            fix_command="chsubserver -r inetd -C /etc/inetd.conf -a -v \"${service_name}\" -p \"${protocol_name}\""
            verbose_message "${fix_command}" "fix"
          fi
        fi
        if [ "${audit_mode}" = 0 ]; then
          update_log_file  "${log_file}" "${actual_value}"
          lockdown_message="Service \"${service_name}\" Protocol \"${protocol_name}\" to \"${correct_value}\""
          if [ "${correct_value}" = "off" ]; then
            lockdown_command="chsubserver -r inetd -C /etc/inetd.conf -d -v ${service_name} -p ${protocol_name}"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          else
            lockdown_command="chsubserver -r inetd -C /etc/inetd.conf -a -v ${service_name} -p ${protocol_name}"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          fi
        fi
      else
        increment_secure "Service \"${service_name}\" Protocol \"${protocol_name}\" is \"${correct_value}\""
      fi
    else
      log_file="${restore_dir}/${log_file}"
      if [ -f "${log_file}" ]; then
        previous_value=$( cat "${log_file}" )
        if [ "${previous_value}" != "${actual_value}" ]; then
          restore_message="Service \"${service_name}\" Protocol \"${protocol_name}\" to \"${previous_value}\""
          if [ "${previous_value}" = "off" ]; then
            restore_command="chsubserver -r inetd -C /etc/inetd.conf -d -v ${service_name} -p ${protocol_name}"
            execute_restore "${restore_command}" "${restore_message}" "sudo"
          else
            restore_command="chsubserver -r inetd -C /etc/inetd.conf -a -v ${service_name} -p ${protocol_name}"
            execute_restore "${restore_command}" "${restore_message}" "sudo"
          fi
        fi
      fi
    fi
  fi
}
