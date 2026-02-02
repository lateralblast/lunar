#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_svccfg_value
#
# Check syscfg settings
#.

audit_svccfg_value () {
  print_function "audit_svccfg_value"
  if [ "${os_name}" = "SunOS" ]; then
    verbose_message "RPC Port Mapping" "check"
    service_name="${1}"
    service_property="${2}"
    correct_value="${3}"
    command="svccfg -s \"${service_name}\" listprop \"${service_property}\" | awk '{print \$3}'"
    command_message "${command}"
    current_value=$( eval "${command}" )
    file_header="svccfg"
    log_file="${work_dir}/${file_header}.log"
    if [ "${audit_mode}" = 2 ]; then
      restore_file="${restore_dir}/${file_header}.log"
      if [ -f "${restore_file}" ]; then
        command="grep \"${service_name}\" \"${restore_file}\" | cut -f2 -d','"
        command_message "${command}"
        restore_property=$( eval "${command}" )
        command="grep \"${service_name}\" \"${restore_file}\" | cut -f3 -d','"
        command_message "${command}"
        restore_value=$( eval "${command}" )
        command="expr \"${restore_property}\" : \"[A-z]\""
        command_message "${command}"
        restore_check=$( eval "${command}" )
        if [ "${restore_check}" = "1" ]; then
          if [ "${current_value}" != "${restore_value}" ]; then
            restore_message="Service \"${service_name}\" Property \"${restore_property}\" to \"${restore_value}\""
            restore_command="svccfg -s ${service_name} setprop ${restore_property} = ${restore_value}"
            command_message "${restore_command}"
            execute_restore "${restore_command}" "${restore_message}" "sudo"
          fi
        fi
      fi
    else
      verbose_message "Service ${service_name}"
    fi
    if [ "${current_value}" != "${correct_value}" ]; then
      lockdown_command="svccfg -s ${service_name} setprop ${service_property} = ${correct_value}"
      if [ "${audit_mode}" = 1 ]; then
        increment_insecure "Service \"${service_name}\" Property \"${service_property}\" not set to \"${correct_value}\""
        verbose_message    "${lockdown_command}" "fix"
      else
        if [ "${audit_mode}" = 0 ]; then
          update_log_file  "${log_file}" "${service_name},${service_property},${current_value}"
          lockdown_message="${service_name} ${service_property} to ${correct_value}"
          execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
        fi
      fi
    else
      if [ "${audit_mode}" != 2 ]; then
        if [ "${audit_mode}" = 1 ]; then
          increment_secure "Service \"${service_name}\" Property \"${service_property}\" already set to \"${correct_value}\""
        fi
      fi
    fi
  fi
}
