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
          if [ "${ansible}" = 1 ]; then
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
            verbose_message "X wrapper to disabled" "set"
            backup_file     "${check_file}"
            tmp_file="/tmp/ttys_${check_string}"
            sed -e '/xdm -nodaemon/s/off/on/' "${check_file}" > "${temp_file}"
            cat "${temp_file}" > "${check_file}"
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
            if [ "${audit_mode}" = 1 ]; then
              increment_insecure "File ${check_file} does not have a security message"
              verbose_message "awk '/xlogin\*greeting:/ { print GreetValue; next }; { print }' GreetValue=\"${greet_mesg}\" < ${check_file} > ${temp_file}" "fix"
              verbose_message "cat ${temp_file} > ${check_file}" "fix"
              verbose_message "rm ${temp_file}"                "fix"
            else
              verbose_message "Security message in ${check_file}" "set"
              backup_file ${check_file}
              awk '/xlogin\*greeting:/ { print GreetValue; next }; { print }' GreetValue="${greet_mesg}" < "${check_file}" > "${temp_file}"
              cat "${temp_file}" > "${check_file}"
              if [ -f "${temp_file}" ]; then
                rm "${temp_file}"
              fi
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
             if [ "${audit_mode}" = 1 ]; then
               increment_insecure "File ${check_file} does not have a security message"
               verbose_message "cat ${check_file} |awk '/GreetString=/ { print \"GreetString=\" GreetString; next }; { print }' GreetString=\"${greet_mesg}\" > ${temp_file}" "fix"
               verbose_message "cat ${temp_file} > ${check_file}" "fix"
               verbose_message "rm ${temp_file}"                "fix"
             else
               verbose_message "Security message in ${check_file}" "set"
               backup_file ${check_file}
               awk '/GreetString=/ { print "GreetString=" GreetString; next }; { print }' GreetString="${greet_mesg}" < "${check_file}" > "${temp_file}"
               cat "${temp_file}" > "${check_file}"
               if [ -f "${temp_file}" ]; then
                 rm "${temp_file}"
               fi
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
            if [ "${audit_mode}" = 1 ]; then
              increment_insecure "X11 nolisten directive not found in file \"${check_file}\""
              verbose_message    "awk '( $1 !~ /^#/ && $3 == \"/usr/X11R6/bin/X\" ) { $3 = $3 \" -nolisten tcp\" }; { print }' < ${check_file} > ${temp_file}" "fix"
              verbose_message    "awk '( $1 !~ /^#/ && $3 == \"/usr/bin/X\" ) { $3 = $3 \" -nolisten tcp\" }; { print }' < ${check_file} > ${temp_file}"       "fix"
              verbose_message    "cat ${temp_file} > ${check_file}" "fix"
              verbose_message    "rm ${temp_file}"                "fix"
            else
              verbose_message "Security message in file \"${check_file}\"" "set"
              backup_file     "${check_file}"
              awk '( $1 !~ /^#/ && $3 == "/usr/X11R6/bin/X" ) { $3 = $3 " -nolisten tcp" }; { print }' < "${check_file}" > "${temp_file}"
              awk '( $1 !~ /^#/ && $3 == "/usr/bin/X" ) { $3 = $3 " -nolisten tcp" }; { print }'< "${check_file}"  > "${temp_file}"
              cat "${temp_file}" > "${check_file}"
              if [ -f "${temp_file}" ]; then
                rm "${temp_file}"
              fi
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
