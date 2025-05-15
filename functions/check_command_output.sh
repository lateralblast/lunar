#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_command_output
#
# Code to test command output
#.

check_command_output () {
  if [ "${os_name}" = "SunOS" ]; then
    command_name="$1"
    ansible_counter=$((ansible_counter+1))
    ansible_value="check_command_output_${command_name}_${ansible_counter}"
    if [ "${command_name}" = "getcond" ]; then
      get_command="auditconfig -getcond |cut -f2 -d'=' |sed 's/ //g'"
    fi
    if [ "${command_name}" = "getpolicy" ]; then
      get_command="auditconfig -getpolicy |head -1 |cut -f2 -d'=' |sed 's/ //g'"
      correct_value="argv,cnt,zonename"
      audit_command="auditconfig -setpolicy"
    fi
    if [ "${command_name}" = "getnaflages" ]; then
      get_command="auditconfig -getpolicy |head -1 |cut -f2 -d'=' |sed 's/ //g' |cut -f1 -d'('"
      correct_value="lo"
      audit_command="auditconfig -setnaflags"
    fi
    if [ "${command_name}" = "getflages" ]; then
      get_command="auditconfig -getflags |head -1 |cut -f2 -d'=' |sed 's/ //g' |cut -f1 -d'('"
      correct_value="lck,ex,aa,ua,as,ss,lo,ft"
      audit_command="auditconfig -setflags"
    fi
    if [ "${command_name}" = "getplugin" ]; then
      get_command="auditconfig -getplugin audit_binfile |tail-1 |cut -f3 -d';'"
      correct_value="p_minfree=1"
      audit_command="auditconfig -setplugin audit_binfile active"
    fi
    if [ "${command_name}" = "userattr" ]; then
      get_command="userattr audit_flags root"
      correct_value="lo,ad,ft,ex,lck:no"
      audit_command="auditconfig -setplugin audit_binfile active"
    fi
    if [ "${command_name}" = "getcond" ]; then
      set_command="auditconfig -conf"
    else
      if [ "${command_name}" = "getflags" ]; then
        set_command="${audit_command} lo,ad,ft,ex,lck"
      else
        set_command="${audit_command} ${correct_value}"
      fi
    fi
    log_file="${command_name}.log"
    check_value=$( ${get_command} )
    if [ "${audit_mode}" != 2 ]; then
      string="Command \"${command_name}\" returns \"${correct_value}\""
      verbose_message "${string}" "check"
       if [ "${ansible}" = 1 ]; then
        echo ""
        echo "- name: Checking ${string}"
        echo "  command: sh -c \"${get_command} |grep '${correct_value}'\""
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
      if [ "${check_value}" != "${correct_value}" ]; then
        increment_insecure "Command \"${command_name}\" does not return correct value"
      else
        increment_secure   "Command \"${command_name}\" returns correct value"
      fi
      update_log_file  "${log_file}" "${audit_command}"
      lockdown_message="Command \"${command_name}\" to correct value"
      lockdown_command="${set_command}"
      execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
    fi
    if [ "${audit_mode}" = 2 ]; then
      restore_file="${restore_dir}/${log_file}"
      if [ -f "${restore_file}" ]; then
        restore_message="Restoring: Previous value for \"${command_name}\""
        if [ "${command_name}" = "getcond" ]; then
          restore_command="${audit_command}"
          execute_restore "${restore_command}" "${restore_message}" "sudo"
        else
          restore_string=$( cat "${restore_file}" )
          restore_command="${audit_command} ${restore_string}"
          execute_restore "${restore_command}" "${restore_message}" "sudo"
        fi
      fi
    fi
  fi
}
