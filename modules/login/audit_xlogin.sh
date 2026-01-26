#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_xlogin
#
# Refer to Section(s) 7.7   Page(s) 26 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.4 Page(s) 38 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.1   Page(s) 15 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 2.1.3 Page(s) 19 CIS Solaris 10 Benchmark v5.1.0
#.

audit_xlogin () {
  print_function "audit_xlogin"
  temp_file="${temp_dir}/audit_xlogin"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "AIX" ] || [ "${os_name}" = "FreeBSD" ] || [ "${os_name}" = "Linux" ]; then
    verbose_message "X Windows" "check"
    if [ "${os_name}" = "AIX" ]; then
      verbose_message "CDE Startup" "check"
      check_itab dt off
    fi
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
       verbose_message "XDMCP Listening"
      fi
      if [ "${os_version}" = "10" ]; then
        check_sunos_service "svc:/application/gdm2-login"                  "disabled"
        check_sunos_service "svc:/application/graphical-login/cde-login"   "disabled"
      fi
      if [ "${os_version}" = "11" ]; then
        check_sunos_service "svc:/application/graphical_login/gdm:default" "disabled"
      fi
      if [ "${os_version}" = "10" ]; then
        check_sunos_service "dtlogin" "disabled"
      fi
    fi
    if [ "${os_name}" = "FreeBSD" ]; then
      check_file="/etc/ttys"
      check_string="nodaemon"
      ttys_test=$( grep ${check_string} ${check_file} | awk '{print $5}' )
      secure_string="X Wrapper is disabled"
      insecure_string="X Wrapper is not disabled"
      verbose_message "${search_string}" "check"
      if [ "${ttys_test}" != "on" ]; then
        if [ "${audit_mode}" != 2 ]; then
          if [ "${ansible_mode}" = 1 ]; then
            echo ""
            echo "- name: Checking ${secure_string}"
            echo "  lineinfile:"
            echo "    path: ${check_file}"
            echo "    regexp: '/xdm -nodaemon/s/off/on/'"
            echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
          fi
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "${insecure_string}"
          fi
          if [ "${audit_mode}" = 2 ]; then
            backup_file      "${check_file}"
            lockdown_message="X wrapper to disabled"
            lockdown_command="sed -e '/xdm -nodaemon/s/off/on/' ${check_file} > ${temp_file} ; cat ${temp_file} > ${check_file} ; rm ${temp_file}"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          fi
        else
          restore_file "${check_file}" "${restore_dir}"
        fi
      else
        if [ "${audit_mode}" = 1 ]; then
          increment_secure "${secure_string}"
        fi
      fi
    fi
    if [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ]; then
      check_file="/etc/X11/xdm/Xresources"
      if [ -f "${check_file}" ]; then
        verbose_message "X Security Message" "check"
        if [ "${audit_mode}" != 2 ]; then
          greet_check=$( grep 'private system' "${check_file}" )
          if [ -z "${greet_check}" ]; then
            verbose_message "File ${check_file} for security message" "check"
            greet_mesg="This is a private system --- Authorized use only!"
            lockdown_command="awk '/xlogin\*greeting:/ { print GreetValue; next }; { print }' GreetValue=\"${greet_mesg}\" < ${check_file} > ${temp_file} ; cat ${temp_file} > ${check_file} ; rm ${temp_file}"
            if [ "${audit_mode}" = 1 ]; then
              increment_insecure "File ${check_file} does not have a security message"
              verbose_message    "${lockdown_command}" "fix"
            else
              backup_file "${check_file}"
              lockdown_message="Security message in ${check_file}"
              execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
            fi
          else
            increment_secure "File \"${check_file}\" has security message"
          fi
        else
          restore_file "${check_file}" "${restore_dir}"
        fi
      fi
      check_file="/etc/X11/xdm/kdmrc"
      if [ -f "${check_file}" ]; then
        verbose_message "X Security Message" "check"
        if [ "${audit_mode}" != 2 ]; then
          greet_check=$( grep -c 'private system' ${check_file} )
          greet_mesg="This is a private system --- Authorized USE only!"
          if [ "${greet_check}" != 1 ]; then
            verbose_message "File ${check_file} for security message"
            lockdown_message="cat ${check_file} |awk '/GreetString=/ { print \"GreetString=\" GreetString; next }; { print }' GreetString=\"${greet_mesg}\" > ${temp_file} ; cat ${temp_file} > ${check_file} ; rm ${temp_file}"
            if [ "${audit_mode}" = 1 ]; then
              increment_insecure "File ${check_file} does not have a security message"
              verbose_message    "${lockdown_command}" "fix"
            else
              backup_file      "${check_file}"
              lockdown_message="Security message in ${check_file}"
              execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
            fi
          else
            increment_secure "File ${check_file} has security message"
          fi
        else
          restore_file "${check_file}" "${restore_dir}"
        fi
      fi
      check_file="/etc/X11/xdm/Xservers"
      if [ -f "${check_file}" ]; then
        verbose_message "X Listening"
        if [ "${audit_mode}" != 2 ]; then
          greet_check=$( grep -c 'nolisten tcp' "${check_file}" )
          if [ "${greet_check}" != 1 ]; then
            verbose_message "For X11 nolisten directive in file \"${check_file}\"" "check"
            lockdown_command_1="awk '( \$1 !~ /^#/ && \$3 == \"/usr/X11R6/bin/X\" ) { \$3 = \$3 \" -nolisten tcp\" }; { print }' < ${check_file} > ${temp_file}"
            lockdown_command_2="awk '( \$1 !~ /^#/ && \$3 == \"/usr/bin/X\" ) { \$3 = \$3 \" -nolisten tcp\" }; { print }' < ${check_file} > ${temp_file}"
            lockdown_command_3="cat ${temp_file} > ${check_file} ; rm ${temp_file}"
            if [ "${audit_mode}" = 1 ]; then
              increment_insecure "X11 nolisten directive not found in file \"${check_file}\""
              verbose_message "${lockdown_command_1}" "fix"
              verbose_message "${lockdown_command_2}" "fix"
              verbose_message "${lockdown_command_3}" "fix"
            else
              backup_file      "${check_file}"
              lockdown_message="Security message in file \"${check_file}\""
              execute_lockdown "${lockdown_command_1}" "${lockdown_message}" "sudo"
              execute_lockdown "${lockdown_command_2}" "${lockdown_message}" "sudo"
              execute_lockdown "${lockdown_command_3}" "${lockdown_message}" "sudo"
            fi
          else
            increment_secure "X11 nolisten directive found in file \"${check_file}\""
          fi
        else
          restore_file "${check_file}" "${restore_dir}"
        fi
      fi
    fi
  fi
}
