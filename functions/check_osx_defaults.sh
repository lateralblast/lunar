#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_osx_defaults
#
# Function to check defaults under OS X
#.

check_osx_defaults () {
  if [ "${os_name}" = "Darwin" ]; then
    defaults_file="$1"
    defaults_parameter="$2"
    defaults_value="$3"
    defaults_type="$4"
    if [ "${defaults_type}" = "dict" ]; then
      defaults_second_value="$5"
      defaults_second_type="$6"
      defaults_user="$7"
    else
      defaults_host="$5"
      defaults_user="$6"
    fi
    defaults_read="read"
    defaults_write="write"
    backup_file=${defaults_file}
    if [ ! "${defaults_host}" = "currentHost" ]; then
      defaults_user="${defaults_host}"
      defaults_host=""
    fi
    ansible_counter=$((ansible_counter+1))
    ansible_value="check_osx_defaults_${ansible_counter}"
    if [ "${defaults_user}" = "" ]; then
      defaults_command="sudo defaults"
    else
      defaults_command="sudo -u ${defaults_user} defaults"
    fi
    if [ "${audit_mode}" != 2 ]; then
      if [ "${defaults_user}" = "" ]; then
        string="Parameter \"${defaults_parameter}\" is set to \"${defaults_value}\" in \"${defaults_file}\""
      else
        string="Parameter \"${defaults_parameter}\" is set to \"${defaults_value}\" in \"${defaults_file}\" for user \"${defaults_user}\""
      fi
      verbose_message "${string}" "check"
      if [ "${defaults_host}" = "currentHost" ]; then
        defaults_read="-currentHost ${defaults_read}"
        defaults_write="-currentHost ${defaults_write}"
        backup_file="$HOME/Library/Preferences/ByHost/${defaults_file}*"
        defaults_command="defaults"
      fi
      null_check=$( eval "${defaults_command} ${defaults_read} ${defaults_file} ${defaults_parameter} 2> /dev/null | wc -l |sed 's/ //g'" )
      if [ "$null_check" = "0" ]; then
        check_value="not-found"
      else
        zero_check=$( eval "${defaults_command} ${defaults_read} ${defaults_file} ${defaults_parameter} 2> /dev/null | sed 's/^ //g' |grep '0' |wc -l |sed 's/ //g'" )
        if [ "${zero_check}" = "1" ]; then
          check_value="0"
        else
          check_vale=$( eval "${defaults_command} ${defaults_read} ${defaults_file} ${defaults_parameter} 2> /dev/null | sed 's/^ //g'" )
        fi
      fi
      temp_value="${defaults_value}"
      if [ "${defaults_type}" = "bool" ]; then
        if [ "${defaults_value}" = "no" ]; then
          temp_value=0
        fi
        if [ "${defaults_value}" = "yes" ]; then
          temp_value=1
        fi
      fi
      if [ "${check_value}" != "${temp_value}" ]; then
        if [ "${defaults_user}" = "" ]; then
          increment_insecure "Parameter \"${defaults_parameter}\" not set to \"${defaults_value}\" in \"${defaults_file}\""
        else
          increment_insecure "Parameter \"${defaults_parameter}\" not set to \"${defaults_value}\" in \"${defaults_file}\" for user \"${defaults_user}\""
        fi
        if [ "${defaults_value}" = "" ]; then
          verbose_message "${defaults_command} delete ${defaults_file} ${defaults_parameter}" "fix"
          set_command="${defaults_command} delete ${defaults_file} ${defaults_parameter}"
        else
          if [ "${defaults_type}" = "bool" ]; then
            verbose_message "${defaults_command} write ${defaults_file} ${defaults_parameter} -bool \"${defaults_value}\"" "fix"
            set_command="${defaults_command} write ${defaults_file} ${defaults_parameter} -bool \"${defaults_value}\""
          else
            if [ "${defaults_type}" = "int" ]; then
              verbose_message "${defaults_command} write ${defaults_file} ${defaults_parameter} -int ${defaults_value}" "fix"
              set_command="${defaults_command} write ${defaults_file} ${defaults_parameter} -int ${defaults_value}"
            else
              if [ "${defaults_type}" = "dict" ]; then
                if [ "${defaults_second_type}" = "bool" ]; then
                  verbose_message "${defaults_command} write ${defaults_file} ${defaults_parameter} -dict ${defaults_value} -bool ${defaults_second_value}" "fix"
                  set_command="${defaults_command} write ${defaults_file} ${defaults_parameter} -dict ${defaults_value} -bool ${defaults_second_value}"
                else
                  if [ "${defaults_second_type}" = "int" ]; then
                    verbose_message "${defaults_command} write ${defaults_file} ${defaults_parameter} -dict ${defaults_value} -int ${defaults_second_value}" "fix"
                    set_command="${defaults_command} write ${defaults_file} ${defaults_parameter} -dict ${defaults_value} -int ${defaults_second_value}"
                  fi
                fi
              else
                verbose_message "${defaults_command} write ${defaults_file} ${defaults_parameter} \"${defaults_value}\"" "fix"
                set_command="${defaults_command} write ${defaults_file} ${defaults_parameter} \"${defaults_value}\""
              fi
            fi
          fi
        fi
        if [ "${audit_mode}" = 0 ]; then
          backup_file "${backup_file}"
          string="Parameter ${defaults_parameter} to ${defaults_value} in ${defaults_file}"
          lockdown_message="${string}"
          if [ "${defaults_value}" = "" ]; then
            lockdown_command="${defaults_command} delete ${defaults_file} ${defaults_parameter}"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          else
            if [ "${defaults_type}" = "bool" ]; then
              lockdown_command="${defaults_command} write ${defaults_file} ${defaults_parameter} -bool ${defaults_value}"
              execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
            else
              if [ "${defaults_type}" = "int" ]; then
                lockdown_command="${defaults_command} write ${defaults_file} ${defaults_parameter} -int ${defaults_value}"
                execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
                if [ "${defaults_file}" = "/Library/Preferences/com.apple.Bluetooth" ]; then
                  killall -HUP blued
                fi
              else
                if [ "${defaults_type}" = "dict" ]; then
                  if [ "${defaults_second_type}" = "bool" ]; then
                    lockdown_command="${defaults_command} write ${defaults_file} ${defaults_parameter} -dict ${defaults_value} -bool ${defaults_second_value}"
                    execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
                  else
                    if [ "${defaults_second_type}" = "int" ]; then
                      lockdown_command="${defaults_command} write ${defaults_file} ${defaults_parameter} -dict ${defaults_value} -int ${defaults_second_value}"
                      execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
                    fi
                  fi
                else
                  lockdown_command="${defaults_command} write ${defaults_file} ${defaults_parameter} \"${defaults_value}\""
                  execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
                fi
              fi
            fi
          fi
        fi
        get_command="${defaults_command} ${defaults_read} ${defaults_file} ${defaults_parameter} 2>&1 |grep ${defaults_value}"
        if [ "${ansible}" = 1 ]; then
          echo ""
          echo "- name: Checking ${string}"
          echo "  command: sh -c \"${get_command}\""
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
      else
        if [ "${defaults_user}" = "" ]; then
          increment_secure "Parameter \"${defaults_parameter}\" is set to \"${defaults_value}\" in \"${defaults_file}\""
        else
          increment_secure "Parameter \"${defaults_parameter}\" is set to \"${defaults_value}\" in \"${defaults_file}\" for user \"${defaults_user}\""
        fi
      fi
    else
      restore_file "${backup_file}" "${restore_dir}"
    fi
  fi
}

check_osx_defaults_dict () {
  check_osx_defaults "$1" "$2" "$3" "$4" "$5" "$6" "" ""
}

check_osx_defaults_int () {
  check_osx_defaults "$1" "$2" "$3" "int" "" "" "" ""
}

check_osx_defaults_bool () {
  check_osx_defaults "$1" "$2" "$3" "bool" "" "" "" ""
}

check_osx_defaults_string () {
  check_osx_defaults "$1" "$2" "$3" "string" "" "" "" ""
}

check_osx_defaults_user () {
  check_osx_defaults "$1" "$2" "$3" "$4" "$5" "" "" ""
}

check_osx_defaults_host () {
  check_osx_defaults "$1" "$2" "$3" "$4" "currentHost" "" "" ""
}

check_osx_defaults_value () {
  check_osx_defaults "$1" "$2" "$3" "" "" "" "" ""
}
