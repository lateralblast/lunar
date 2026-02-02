#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_serial_login
#
# Refer to Section(s) 3.1    Page(s) 9     CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.12.1 Page(s) 206-7 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 6.1    Page(s) 46-7  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.2    Page(s) 87-8  CIS Solaris 10 Benchmark v5.1.0
#.

audit_serial_login () {
  print_function "audit_serial_login"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "FreeBSD" ] || [ "${os_name}" = "AIX" ]; then
    verbose_message "Login on Serial Ports" "check"
    if [ "${os_name}" = "AIX" ]; then
      command="lsitab –a | grep \"on:/usr/sbin/getty\" | awk '{print \$2}'"
      command_message "${command}"
      tty_list=$( eval "${command}" )
      if [ -z "${tty_list}" ]; then
        if [ "${audit_mode}" = 1 ]; then
          increment_secure "Serial port logins disabled"
        fi
        if [ "${audit_mode}" = 2 ]; then
          command="lsitab –a | grep \"/usr/sbin/getty\" | awk '{print \$2}'"
          command_message "${command}"
          tty_list=$( eval "${command}" )
          for tty_name in ${tty_list}; do
            log_file="${restore_dir}/${tty_name}"
            if [ -f "${log_file}" ]; then
              command="cat \"${log_file}\""
              command_message "${command}"
              previous_value=$( eval "${command}" )
              verbose_message "TTY \"${tty_name}\" to \"${previous_value}\"" "restore"
              command="chitab \"${previous_value} ${tty_name}\""
              command_message "${command}"
              eval "${command}"
            fi
          done
        fi
      else
        for tty_name in ${tty_list}; do
          if [ "${audit_mode}" != 2 ]; then
            log_file="${work_dir}/${tty_name}"
            command="lsitab -a | grep \"on:/usr/sbin/getty\" | grep \"${tty_name}\""
            command_message "${command}"
            actual_value=$( eval "${command}" )
            command="echo \"${actual_value}\" | sed 's/on/off/g'"
            command_message "${command}"
            new_value=$( eval "${command}" )
            if [ "${audit_mode}" = 1 ]; then
              increment_insecure "Serial port logins not disabled on \"${tty_name}\""
              verbose_message    "chitab \"${new_value}\"" "fix"
            fi
            if [ "${audit_mode}" = 0 ]; then
              command="echo \"${actual_value}\" > \"${log_file}\""
              command_message "${command}"
              eval "${command}"
              command="chitab \"${new_value} ${tty_name}\""
              command_message "${command}"
              eval "${command}"
            fi
          else
            log_file="${restore_dir}/${tty_name}"
            if [ -f "${log_file}" ]; then
              command="cat \"${log_file}\""
              command_message "${command}"
              previous_value=$( eval "${command}" )
              verbose_message "Restoring: TTY \"${tty_name}\" to \"${previous_value}\""
              command="chitab \"${previous_value} ${tty_name}\""
              command_message "${command}"
              eval "${command}"
            fi
          fi
        done
      fi
    fi
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" != "11" ]; then
        command="pmadm -L | grep -E \"ttya|ttyb\" | cut -f4 -d \":\" | grep -c \"ux\""
        command_message "${command}"
        serial_test=$( eval "${command}" )
        log_file="${work_dir}/pmadm.log"
        command="expr \"$serial_test\" : \"2\""
        command_message "${command}"
        serial_check=$( eval "${command}" )
        if [ "${serial_check}" = "1" ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_secure "Serial port logins disabled"
          fi
        else
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "Serial port logins not disabled"
            verbose_message    "pmadm -d -p zsmon -s ttya" "fix"
            verbose_message    "pmadm -d -p zsmon -s ttyb" "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            verbose_message "Serial port logins to disabled" "set"
            command="echo \"ttya,ttyb\" >> \"${log_file}\""
            command_message "${command}"
            eval "${command}"
            command="pmadm -d -p zsmon -s ttya"
            command_message "${command}"
            eval "${command}"
            command="pmadm -d -p zsmon -s ttyb"
            command_message "${command}"
            eval "${command}"
          fi
        fi
        if [ "${audit_mode}" = 2 ]; then
          restore_file="${restore_dir}/pmadm.log"
          if [ -f "${restore_file}" ]; then
            verbose_message "Serial port logins to enabled" "restore"
            command="pmadm -e -p zsmon -s ttya"
            command_message "${command}"
            eval "${command}"
            command="pmadm -e -p zsmon -s ttyb"
            command_message "${command}"
            eval "${command}"
          fi
        fi
      fi
    fi
    if [ "${os_name}" = "FreeBSD" ]; then
      check_file="/etc/ttys"
      check_string="dialup"
      command="grep \"${check_string}\" \"${check_file}\" |awk '{print \$5}'"
      command_message "${command}"
      ttys_test=$( eval "${command}" )
      if [ "${ttys_test}" != "off" ]; then
        if [ "${audit_mode}" != 2 ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "Serial port logins not disabled"
          fi
          if [ "${audit_mode}" = 2 ]; then
            verbose_message "Serial port logins to disabled" "set"
            backup_file     "${check_file}"
            temp_file="${temp_dir}/ttys_${check_string}"
            command="awk '(\\$4 == \"dialup\") { \\$5 = \"off\" } { print }' < \"${check_file}\" > \"${temp_file}\""
            command_message "${command}"
            eval "${command}"
            command="cat \"${temp_file}\" > \"${check_file}\""
            command_message "${command}"
            eval "${command}"
          fi
        else
          restore_file "${check_file}" "${restore_dir}"
        fi
      else
        if [ "${audit_mode}" = 1 ]; then
          increment_secure "Serial port logins disabled"
        fi
      fi
    fi
  fi
}
