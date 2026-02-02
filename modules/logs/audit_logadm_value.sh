#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2028
# shellcheck disable=SC2034
# shellcheck disable=SC2046
# shellcheck disable=SC2154

# audit_logadm_value
#
# Enable Debug Level Daemon Logging. Improved logging capability.
#
# Refer to Section(s) 4.3 Page(s) 67-8 CIS Solaris 10 Benchmark v5.1.0
#.

audit_logadm_value () {
  print_function "audit_logadm_value"
  string="Debug Level Daemon Logging"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      log_name="${1}"
      log_facility="${2}"
      check_file="/etc/logadm.conf"
      command="logadm -V | grep -v '^#' | grep \"${log_name}\""
      command_message "${command}"
      check_log=$( eval "${command}" )
      log_file="/var/log/${log_name}"
      if [ -z "$log_check" ]; then
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure  "Logging for \"${log_name}\" not enabled"
          verbose_message     "logadm -w ${log_name} -C 13 -a 'pkill -HUP syslogd' ${log_file}" "fix"
          verbose_message     "svcadm refresh svc:/system/system-log" "fix"
        else
          if [ "${audit_mode}" = 0 ]; then
            verbose_message   "Syslog to capture \"${log_facility}\"" "set"
          fi
          backup_file "${check_file}"
          if [ "${log_facility}" != "none" ]; then
            check_file="/etc/syslog.conf"
            if [ ! -f "${work_dir}${check_file}" ]; then
              echo "Saving:    File ${check_file} to ${work_dir}${check_file}"
              command="find \"${check_file}\" | cpio -pdm \"${work_dir}\" 2> /dev/null"
              command_message "${command}"
              eval "${command}"
            fi
          fi
          echo  "${log_facility}\t\t\t${log_file}" >> "${check_file}"
          touch "${log_file}"
          chown root:root "${log_file}"
          if [ "${log_facility}" = "none" ]; then
            command="logadm -w \"${log_name}\" -C 13 \"${log_file}\""
            command_message "${command}"
            eval "${command}"
          else
            command="logadm -w \"${log_name}\" -C 13 -a 'pkill -HUP syslogd' \"${log_file}\""
            command_message "${command}"
            eval "${command}"
            svcadm refresh svc:/system/system-log
          fi
        fi
        if [ "${audit_mode}" = 2 ]; then
          if [ -f "${restore_dir}/${check_file}" ]; then
            cp -p "${restore_dir}/${check_file}" "${check_file}"
            if [ "${os_version}" != "11" ]; then
              command="pkgchk -f -n -p ${check_file} 2> /dev/null"
              command_message "${command}"
              eval "${command}"
            else
              command="pkg fix \$( pkg search ${check_file} | grep pkg | awk '{print \$4}' )"
              command_message "${command}"
              eval "${command}"
            fi
          fi
          if [ "${log_facility}" = "none" ]; then
            check_file="/etc/syslog.conf"
            if [ -f "${restore_dir}/${check_file}" ]; then
              cp -p "${restore_dir}/${check_file}" "${check_file}"
              if [ "${os_version}" != "11" ]; then
                command="pkgchk -f -n -p \"${check_file}\" 2> /dev/null"
                command_message "${command}"
                eval "${command}"
              else
                command="pkg fix \$( pkg search \"${check_file}\" | grep pkg | awk '{print \$4}' )"
                command_message "${command}"
                eval "${command}"
              fi
            fi
            svcadm refresh svc:/system/system-log
          fi
        fi
      else
        if [ "${audit_mode}" = 1 ]; then
          increment_secure "Logging for \"${log_name}\" already enabled"
        fi
      fi
    fi
  else
    na_message "${string}"
  fi
}
