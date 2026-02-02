#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_remote_consoles
#
# Check remote consoles
#
# Refer to Section(s) 9.1 Page(s) 72  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.1 Page(s) 116 CIS Solaris 10 Benchmark v5.1.0
#.

audit_remote_consoles () {
  print_function "audit_remote_consoles"
  string="Remote Consoles"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    log_file="remoteconsoles.log"
    if [ "${audit_mode}" != 2 ]; then
      disable_ttys=0
      log_file="${work_dir}/${log_file}"
      command="/usr/sbin/consadm -p"
      command_message "${command}"
      console_list=$( eval "${command}" )
      for console_device in $console_list; do
        disable_ttys=1
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure "Console enabled on \"${console_device}\""
          verbose_message    "consadm -d ${console_device}" "fix"
        fi
        if [ "${audit_mode}" = 0 ]; then
          echo "${console_device}" >> "${log_file}"
          verbose_message   "Console disabled on \"${console_device}\""   "set"
          command="consadm -d \"${console_device}\""
          command_message "${command}"
          eval "${command}"
        fi
      done
      if [ "${disable_ttys}" = 0 ]; then
        if [ "${audit_mode}" = 1 ]; then
          increment_secure  "No remote consoles enabled"
        fi
      fi
    else
      restore_file="${restore_dir}${log_file}"
      if [ -f "${restore_file}" ]; then
        command="cat \"${restore_file}\""
        command_message "${command}"
        restore_list=$( eval "${command}" )
        for console_device in ${restore_list}; do
          verbose_message   "Console to enabled on \"${console_device}\"" "restore"
          command="consadm -a \"${console_device}\""
          command_message "${command}"
          eval "${command}"
        done
      fi
    fi
  else
    na_message "${string}"
  fi
}
