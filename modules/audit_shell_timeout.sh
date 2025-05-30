#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_shell_timeout
#
# Check Shell Timeout settings
#
# Refer to Section(s) 5.4.3.2 Page(s) 714-8 CIS Ubuntu 24.04 Benchmark v1.0.0
#
# Refer to: http://pubs.vmware.com/vsphere-55/topic/com.vmware.wssdk.apiref.doc/vim.option.OptionManager.html
#.

audit_shell_timeout () {
  print_function "audit_shell_timeout"
  if [ "${os_name}" = "VMkernel" ]; then
    for test in ESXiShellInteractiveTimeOut ESXiShellTimeOut; do
      timeout="3600"
      verbose_message "Timeoute value for \"${test}\"" "check"
      backup_file="${work_dir}/${test}"
      current_value=$( esxcli --formatter=csv --format-param=fields="Path,Int Value" system settings advanced list | grep "/UserVars/${test}" | cut -f2 -d, )
      if [ "${audit_mode}" != "2" ]; then
        if [ "${current_value}" != "${timeout}" ]; then
          if [ "${audit_mode}" = "0" ]; then
            echo "${current_value}" > "${backup_file}"
            verbose_message "Timeout value for ${test} to ${timeout}" "set"
            esxcli system settings advanced set -o "/UserVars/${test}" -i "${timeout}"
          fi
          if [ "${audit_mode}" = "1" ]; then
            increment_insecure  "Timeout value for ${test} not set to ${timeout}"
            verbose_message     "esxcli system settings advanced set -o /UserVars/${test} -i ${timeout}" "fix"
          fi
        else
          if [ "${audit_mode}" = "1" ]; then
            increment_secure "Timeout value for ${test} is set to ${timeout}"
          fi
        fi
      else
        restore_file="${restore_dir}/${test}"
        if [ -f "${restore_file}" ]; then
          previous_value=$( cat "${restore_file}" )
          if [ "${previous_value}" != "${current_value}" ]; then
            verbose_message "Restoring: Shell timeout to ${previous_value}"
            esxcli system settings advanced set -o "/UserVars/${test}" -i "${previous_value}"
          fi
        fi
      fi
    done
  else
    if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ]; then
      for check_file in /etc/.login /etc/profile /etc/skel/.bash_profile /etc/csh.login /etc/csh.cshrc \
        /etc/zprofile /etc/skel/.zshrc /etc/skel/.bashrc /etc/bashrc /etc/skel/.bashrc /etc/login.defs; do
        check_file_value "is" "${check_file}" "TMOUT" "eq" "900" "hash"
      done
    fi 
  fi
}
