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
  print_module "audit_serial_login"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "FreeBSD" ] || [ "${os_name}" = "AIX" ]; then
    verbose_message "Login on Serial Ports" "check"
    if [ "${os_name}" = "AIX" ]; then
      tty_list=$( lsitab –a | grep "on:/usr/sbin/getty" | awk '{print $2}' )
      if [ -z "${tty_list}" ]; then
        if [ "${audit_mode}" = 1 ]; then
          increment_secure "Serial port logins disabled"
        fi
        if [ "${audit_mode}" = 2 ]; then
          tty_list=$( lsitab –a | grep "/usr/sbin/getty" | awk '{print $2}' )
          for tty_name in ${tty_list}; do
            log_file="${restore_dir}/${tty_name}"
            if [ -f "${log_file}" ]; then
              previous_value=$( cat "${log_file}" )
              verbose_message "TTY \"${tty_name}\" to \"${previous_value}\"" "restore"
              chitab "${previous_value} ${tty_name}"
            fi
          done
        fi
      else
        for tty_name in ${tty_list}; do
          if [ "${audit_mode}" != 2 ]; then
            log_file="${work_dir}/${tty_name}"
            actual_value=$( lsitab -a | grep "on:/usr/sbin/getty" | grep "${tty_name}" )
            new_value=$( echo "${actual_value}" | sed 's/on/off/g' )
            if [ "${audit_mode}" = 1 ]; then
              increment_insecure "Serial port logins not disabled on \"${tty_name}\""
              verbose_message    "chitab \"${new_value}\"" "fix"
            fi
            if [ "${audit_mode}" = 0 ]; then
              echo   "${actual_value}" > "${log_file}"
              chitab "${new_value} ${tty_name}"
            fi
          else
            log_file="${restore_dir}/${tty_name}"
            if [ -f "${log_file}" ]; then
              previous_value=$( cat "${log_file}" )
              verbose_message "Restoring: TTY \"${tty_name}\" to \"${previous_value}\""
              chitab "${previous_value} ${tty_name}"
            fi
          fi
        done
      fi
    fi
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" != "11" ]; then
        serial_test=$( pmadm -L | grep -E "ttya|ttyb" | cut -f4 -d ":" | grep -c "ux" )
        log_file="${work_dir}/pmadm.log"
        serial_check=$( expr "$serial_test" : "2" )
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
            echo "ttya,ttyb" >> "${log_file}"
            pmadm -d -p zsmon -s ttya
            pmadm -d -p zsmon -s ttyb
          fi
        fi
        if [ "${audit_mode}" = 2 ]; then
          restore_file="${restore_dir}/pmadm.log"
          if [ -f "${restore_file}" ]; then
            verbose_message "Serial port logins to enabled" "restore"
            pmadm -e -p zsmon -s ttya
            pmadm -e -p zsmon -s ttyb
          fi
        fi
      fi
    fi
    if [ "${os_name}" = "FreeBSD" ]; then
      check_file="/etc/ttys"
      check_string="dialup"
      ttys_test=$( grep "${check_string}" "${check_file}" |awk '{print $5}' )
      if [ "${ttys_test}" != "off" ]; then
        if [ "${audit_mode}" != 2 ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "Serial port logins not disabled"
          fi
          if [ "${audit_mode}" = 2 ]; then
            verbose_message "Serial port logins to disabled" "set"
            backup_file     "${check_file}"
            temp_file="${temp_dir}/ttys_${check_string}"
            awk '($4 == "dialup") { $5 = "off" } { print }' < "${check_file}" > "${temp_file}"
            cat "${temp_file}" > "${check_file}"
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
