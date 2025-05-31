#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2046
# shellcheck disable=SC2086
# shellcheck disable=SC2154

# check_file_value
#
# Audit file values
#
# This routine takes the following values
#
# check_file      = The name of the file to check
# parameter_name  = The parameter to be checked
# seperator       = Character used to seperate parameter name from it's value (eg =)
# correct_value   = The value we expect to be returned
# comment_value   = Character used as a comment (can be #, *, etc)
#                   Needs to be passed as word, e.g. hash, star, bang, semicolon, eq, space, colon
# position        = E.g. after
# search_value    = Additional search term to help locate parameter / value
#
# If the current_value is not the correct_value then it is fixed if run in lockdown mode
# A copy of the value is stored in a log file, which can be restored
#.

check_file_value_with_position () {
  print_function "check_file_value_with_position"
  operator="$1"
  check_file="$2"
  parameter_name="$3"
  separator="$4"
  correct_value="$5"
  comment_value="$6"
  position="$7"
  search_value="$8"
  temp_file=$( basename ${check_file} )
  temp_file="${temp_dir}/${temp_file}"
  dir_name=$( dirname "${check_file}" )
  sshd_test=$( echo "${check_file}" | grep -c "sshd_config" | sed "s/ //g" )
  if [ ! -f "${check_file}" ]; then
    verbose_message "File \"${check_file}\" does not exist" "warn"
  fi
  if [ ! -d "${dir_name}" ]; then
    verbose_message "Directory \"${dir_name}\" does not exist" "warn"
  else
    if [ "${operator}" = "set" ]; then
      correct_value="[A-Z,a-z,0-9]"
      operator="is"
    fi
    if [ "${comment_value}" = "star" ]; then
      comment_value="*"
    else
      if [ "${comment_value}" = "bang" ]; then
        comment_value="!"
      else
        if [ "${comment_value}" = "semicolon" ]; then
          comment_value=";"
        else
          comment_value="#"
        fi
      fi
    fi
    sep_test=$( expr "${separator}" : "eq" )
    if [ "${sep_test}" = 2 ]; then
      separator="="
      spacer="\="
    else
      sep_test=$( expr "${separator}" : "space" )
      if [ "${sep_test}" = 5 ]; then
        separator=" "
        spacer=" "
      else
        sep_test=$( expr "${separator}" : "colon" )
        if [ "${sep_test}" = 5 ]; then
          separator=":"
          space=":"
        fi
      fi
    fi
    if [ "${operator}" = "is" ] || [ "${operator}" = "in" ]; then
      negative="not"
    else
      negative="is"
    fi
    if [ "${id_check}" = "0" ] || [ "${os_name}" = "VMkernel" ]; then
      cat_command="cat"
      sed_command="sed"
      echo_command="echo"
    else
      cat_command="sudo cat"
      sed_command="sudo sed"
      echo_command="sudo echo"
    fi
    if [ "${check_file}" = "/etc/audit/auditd.conf" ] || [ "${check_file}" = "/etc/security/faillock.conf" ] || [ "${check_file}" = "/etc/security/pwquality.conf" ]; then
      spacer=" ${spacer} "
    fi
    if [ "${audit_mode}" = 2 ]; then
      restore_file "${check_file}" "${restore_dir}"
    else
      string="Value of \"${parameter_name}\" ${operator} set to \"${correct_value}\" in \"${check_file}\""
      verbose_message "${string}" "check"
      string="Parameter ${parameter_name} to ${correct_value} in ${check_file}"
      lockdown_message="Value of \"${parameter_name}\" to \"${correct_value}\" in \"${check_file}\""
      if [ ! -f "${check_file}" ]; then
        if [ "${check_file}" = "/etc/default/sendmail" ] || [ "${check_file}" = "/etc/sysconfig/mail" ] || [ "${check_file}" = "/etc/rc.conf" ] || [ "${check_file}" = "/boot/loader.conf" ] || [ "${check_file}" = "/etc/sysconfig/boot" ] || [ "${check_file}" = "/etc/sudoers" ]; then
          line="${parameter_name}${separator}\"${correct_value}\""
        else
          line="${parameter_name}${separator}${correct_value}"
        fi
        lockdown_command="echo '${line}' >> ${check_file}"
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure "Parameter \"${parameter_name}\" ${negative} set to \"${correct_value}\" in \"${check_file}\""
          verbose_message "${lockdown_command}" "fix"
        else
          if [ "${audit_mode}" = 0 ]; then
            log_file="${restore_dir}/fileops.log"
            update_log_file "${log_file}" "rm,${check_file}"
            backup_file "${check_file}"
            if [ "${check_file}" = "/etc/system" ]; then
              reboot_required=1
              verbose_message "Reboot required" "notice"
            fi
            if [ "$sshd_test" =  "1" ]; then
              verbose_message "Service restart required for SSH" "notice"
            fi
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          fi
          if [ "${ansible_mode}" = 1 ]; then
            echo ""
            echo "- name: Checking ${string}"
            echo "  lineinfile:"
            echo "    path: ${check_file}"
            echo "    line: '${line}'"
            echo "    create: yes"
            echo ""
          fi
        fi
      else
        correct_hyphen=$( echo "${correct_value}" | grep -c "^[\-]" | sed "s/ //g" )
        if [ "${correct_hyphen}" = "1" ]; then
          correct_value="\\${correct_value}"
        fi
        param_hyphen=$( echo "${parameter_name}" | grep -c "^[\-]" | sed "s/ //g" )
        if [ "${param_hyphen}" = "1" ]; then
          parameter_name="\\${parameter_name}"
        fi
        if [ "${separator}" = "tab" ]; then
          check_value=$( ${cat_command} "${check_file}" | grep -v "^${comment_value}" | grep "${parameter_name}" | awk '{print $2}' | sed 's/"//g' | uniq | grep -cE "${correct_value}" | sed "s/ //g" )
        else
          if [ "$sshd_test" = "1" ]; then
            check_value=$( ${cat_command} "${check_file}" | grep -v "^${comment_value}" | grep "${parameter_name}" | cut -f2 -d"${separator}" | sed 's/"//g' | sed 's/ //g' | uniq | grep -cE "${correct_value}" | sed "s/ //g" )
            if [ ! "${check_value}" ]; then
              check_value=$( ${cat_command} "${check_file}" | grep "${parameter_name}" | cut -f2 -d"${separator}" | sed 's/"//g' | sed 's/ //g' | uniq | grep -cE "${correct_value}" | sed "s/ //g" )
            fi
          else
            if [ "${search_value}" ]; then
              if [ "${operator}" = "is" ]; then
                check_value=$( ${cat_command} "${check_file}" | grep -v "^${comment_value}" | grep "${parameter_name}" | cut -f2 -d"${separator}" | sed 's/"//g' | sed 's/ //g' | uniq | grep -cE "${search_value}" | sed "s/ //g" )
              else
                check_value=$( ${cat_command} "${check_file}" | grep -v "^${comment_value}" | grep "${parameter_name}" | grep "${separator}" | uniq | grep -cE "${search_value}" | sed "s/ //g" )
              fi
            else
              if [ "${operator}" = "is" ]; then
                check_value=$( ${cat_command} "${check_file}" | grep -v "^${comment_value}" | grep "${parameter_name}" | cut -f2 -d"${separator}" | sed 's/"//g' | sed 's/ //g' | uniq | grep -cE "${correct_value}" | sed "s/ //g" )
              else
                check_value=$( ${cat_command} "${check_file}" | grep -v "^${comment_value}" | grep "${parameter_name}" | grep "${separator}" | uniq | grep -cE "${correct_value}" | sed "s/ //g" )
              fi
            fi
          fi
        fi
        if [ "${operator}" = "is" ] || [ "${operator}" = "in" ]; then
          if [ "${check_value}"  = "1" ]; then
            test_value=1
          else
            test_value=0
          fi
        else
          if [ "${check_value}" = "" ]; then
            test_value=0
          else
            test_value=1
          fi
        fi
        if [ "${ansible_mode}" = 1 ]; then
          if [ "${negative}" = "not" ]; then
            line="${parameter_name}${separator}${correct_value}"
          else
            line="${comment_value}${parameter_name}${separator}${correct_value}"
          fi
          echo ""
          echo "- name: ${string}"
          echo "  lineinfile:"
          echo "    path: ${check_file}"
          echo " .  regex: '^${parameter_name}'"
          echo "    line: '${line}'"
          echo ""
        fi
        if [ "${separator}" = "tab" ]; then
          check_parameter=$( ${cat_command} "${check_file}" | grep -v "^${comment_value}" | grep "${parameter_name}" | awk '{print $1}' )
        else
          check_parameter=$( ${cat_command} "${check_file}" | grep -v "^${comment_value}" | grep "${parameter_name}" | cut -f1 -d"${separator}" | sed 's/ //g' | uniq )
        fi
        if [ "$test_value" = 0 ]; then
          correct_hyphen=$( echo "${correct_value}" | grep -c "^[\\]" | sed "s/ //g" )
          if [ "${correct_hyphen}" = "1" ]; then
            correct_value=$( echo "${correct_value}" | sed "s/^[\\]//g" )
          fi
          param_hyphen=$( echo "${parameter_name}" | grep -c "^[\\]" | sed "s/ //g" )
          if [ "${param_hyphen}" = "1" ]; then
            parameter_name=$( echo "${parameter_name}" | sed "s/^[\\]//g" )
          fi
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "Parameter \"${parameter_name}\" ${negative} set to \"${correct_value}\" in \"${check_file}\""
            if [ "${check_parameter}" != "${parameter_name}" ]; then
              if [ "${separator}" = "tab" ]; then
                verbose_message "echo -e \"${parameter_name}\t${correct_value}\" >> ${check_file}" "fix"
              else
                if [ "${position}" = "after" ]; then
                  verbose_message "${cat_command} ${check_file} | sed \"s,${search_value},&\\\n${parameter_name}${separator}${correct_value},\" > ${temp_file}" "fix"
                  verbose_message "${cat_command} ${temp_file} > ${check_file}" "fix"
                else
                  verbose_message "echo \"${parameter_name}${separator}${correct_value}\" >> ${check_file}" "fix"
                fi
              fi
            else
              if [ "${check_file}" = "/etc/default/sendmail" ] || [ "${check_file}" = "/etc/sysconfig/mail" ] || [ "${check_file}" = "/etc/rc.conf" ] || [ "${check_file}" = "/boot/loader.conf" ] || [ "${check_file}" = "/etc/sysconfig/boot" ] || [ "${check_file}" = "/etc/sudoers" ]; then
                verbose_message "${sed_command} \"s/^${parameter_name}.*/${parameter_name}${spacer}\"${correct_value}\"/\" ${check_file} > ${temp_file} ; cat ${temp_file} > ${check_file} ; rm ${temp_file}" "fix"
              else
                verbose_message "${sed_command} \"s/^${parameter_name}.*/${parameter_name}${spacer}${correct_value}/\" ${check_file} > ${temp_file} ; cat ${temp_file} > ${check_file} ; rm ${temp_file}" "fix"
              fi
            fi
          else
            if [ "${audit_mode}" = 0 ]; then
              verbose_message "Parameter \"${parameter_name}\" to \"${correct_value}\" in \"${check_file}\"" "set"
              if [ "${check_file}" = "/etc/system" ]; then
                reboot_required=1
                verbose_message "Reboot required" "notice"
              fi
              if [ "${check_file}" = "/etc/ssh/sshd_config" ] || [ "${check_file}" = "/etc/sshd_config" ]; then
                verbose_message "Service restart required for SSH" "notice"
              fi
              backup_file "${check_file}"
              if [ "${check_parameter}" != "${parameter_name}" ]; then
                if [ "${separator_value}" = "tab" ]; then
                  lockdown_command="${echo_command} -e \"${parameter_name}\t${correct_value}\" >> ${check_file}"
                else
                  if [ "${position}" = "after" ]; then
                    lockdown_command="${cat_command} ${check_file} | sed \"s,${search_value},&\\\n${parameter_name}${separator}${correct_value},\" > ${temp_file} ; ${cat_command} ${temp_file} > ${check_file} ; rm ${temp_file}"
                  else
                    lockdown_command="${echo_command} \"${parameter_name}${separator}${correct_value}\" >> ${check_file}"
                  fi
                fi
                execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
              else
                if [ "${check_file}" = "/etc/default/sendmail" ] || [ "${check_file}" = "/etc/sysconfig/mail" ] || [ "${check_file}" = "/etc/rc.conf" ] || [ "${check_file}" = "/boot/loader.conf" ] || [ "${check_file}" = "/etc/sysconfig/boot" ] || [ "${check_file}" = "/etc/sudoers" ]; then
                  lockdown_command="${sed_command} \"s/^${parameter_name}.*/${parameter_name}${spacer}\\"${correct_value}\\"/\" ${check_file} > ${temp_file} ; cat ${temp_file} > ${check_file} ; rm ${temp_file}"
                else
                  lockdown_command="${sed_command} \"s/^${parameter_name}.*/${parameter_name}${spacer}${correct_value}/\" ${check_file} > ${temp_file} ; cat ${temp_file} > ${check_file} ; rm ${temp_file}"
                fi
                execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
                if [ "${os_name}" = "SunOS" ]; then
                  if [ "${os_version}" != "11" ]; then
                    pkgchk -f -n -p "${check_file}" 2> /dev/null
                  else
                    pkg fix $( pkg search "${check_file}" | grep pkg | awk '{print $4}' )
                  fi
                fi
              fi
            fi
          fi
        else
          increment_secure "Parameter \"${parameter_name}\" ${operator} set to \"${correct_value}\" in \"${check_file}\""
        fi
      fi
    fi
  fi
}

check_file_value () {
  if [ -n "$7" ]; then
    check_file_value_with_position  "$1" "$2" "$3" "$4" "$5" "$6" "$7" ""
  else
    if [ -n "$8" ]; then
      check_file_value_with_position  "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8"
    else
      check_file_value_with_position  "$1" "$2" "$3" "$4" "$5" "$6" "" ""
    fi
  fi
}
