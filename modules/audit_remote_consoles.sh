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
  if [ "${os_name}" = "SunOS" ]; then
    verbose_message "Remote Consoles" "check"
    log_file="remoteconsoles.log"
    if [ "${audit_mode}" != 2 ]; then
      disable_ttys=0
      log_file="${work_dir}/${log_file}"
      console_list=$( /usr/sbin/consadm -p )
      for console_device in $console_list; do
        disable_ttys=1
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure "Console enabled on \"${console_device}\""
          verbose_message    "consadm -d ${console_device}" "fix"
        fi
        if [ "${audit_mode}" = 0 ]; then
          echo "${console_device}" >> "${log_file}"
          verbose_message   "Console disabled on \"${console_device}\""   "set"
          consadm -d "${console_device}"
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
        restore_list=$( cat "${restore_file}" )
        for console_device in ${restore_list}; do
          verbose_message   "Console to enabled on \"${console_device}\"" "restore"
          consadm -a "${console_device}"
        done
      fi
    fi
  fi
}
