#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_gsettings_value
#
# Audit gsettings values
#
# This routine takes the followinf values
#
# parameter_root  = The parameter root to be checked
# parameter_name  = The parameter name to be checked
# correct_value   = The value we expect to be returned
#
# If the current_value is not the correct_value then it is fixed if run in lockdown mode
# A copy of the value is stored in a log file, which can be restored
#.

check_gsettings_value () {
  print_function "check_gsettings_value"
  parameter_root="$1"
  parameter_name="$2" 
  correct_value="$3"
  command_name="gsettings"
  log_file="${command_name}.log"
  check=$( command -v gsettings 2> /dev/null | wc -l | sed "s/ //g" )
  if [ "${check}" = "1" ]; then
    string="Parameter \"${parameter_name}\" to \"${correct_value}\""
    verbose_message "${string}" "check"
    set_command="gsettings set"
    get_command="gsettings get"
    if [ "${os_name}" = "Linux" ]; then
      if [ "${audit_mode}" = 2 ]; then
        restore_file="${restore_dir}/${log_file}"
        if [ -f "${restore_file}" ]; then
          parameter_root=$( grep "${parameter_name}" "${restore_file}" | cut -f1 -d',' )
          parameter_name=$( grep "${parameter_name}" "${restore_file}" | cut -f2 -d',' )
          correct_value=$( grep "${parameter_name}" "${restore_file}" | cut -f3 -d',' )
          package_test=$( echo "${parameter_name}" | grep "[A-z]" )
          if [ -n "${package_test}" ]; then
            restore_message="Parameter \"${parameter_name}\" to \"${correct_value}\""
            restore_command="${set_command} ${parameter_root} ${parameter_name} ${correct_value}"
            execute_restore "${restore_command}" "${restore_message}" "sudo"
          fi
        fi
      else
        value_check=$( gsettings get "${parameter_root}" "${parameter_name}" 2>  /dev/null | grep -c "${correct_value}" | sed "s/ //g" )
        if [ "${value_check}" = "0" ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "Parameter \"${parameter_name}\" is not set to \"${correct_value}\" in ${parameter_root}"
            string="Parameter \"${parameter_root}.${parameter_name}\" to \"${correct_value}\""
            if [ "${ansible_mode}" = 1 ]; then
              echo ""
              echo "- name: Setting ${string}"
              echo "  gsetting:"
              echo "    ${parameter_root}.${parameter_name}: ${correct_value}"
              echo ""
            fi
            verbose_message "${set_command} ${parameter_root} ${parameter_name} \"${correct_value}\"" "fix"
          else
            current_value=$( gsettings get "${parameter_root}" "${parameter_name}" 2> /dev/null )
            if [ "${audit_mode}" = 0 ]; then
              update_log_file "${log_file}" "${parameter_root},${parameter_name},${current_value}"
              lockdown_message="Parameter \"${parameter_name}\" to \"${correct_value}\""
              lockdown_command="${set_command} ${parameter_root} ${parameter_name} ${correct_value}"
              execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
            fi
          fi
        else
          if [ "${audit_mode}" = 1 ]; then
            increment_secure "Parameter \"${parameter_name}\" is set to \"${correct_value}\" in ${parameter_root}"
          fi
        fi
      fi 
    fi
  fi
}