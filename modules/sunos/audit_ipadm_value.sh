#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ipadm_value
#
# Code to drive ipadm on Solaris 11
#.

audit_ipadm_value () {
  print_function "audit_ipadm_value"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "11" ]; then
      ipadm_name="${1}"
      ipadm_property="${2}"
      correct_value="${3}"
      current_value=$( ipadm show-prop -p "${ipadm_name}" -co current "${ipadm_property}" )
      file_header="ipadm"
      log_file="${work_dir}/${file_header}.log"
      if [ "${audit_mode}" = 2 ]; then
        restore_file="${restore_dir}/${file_header}.log"
        if [ -f "${restore_file}" ]; then
          restore_property=$( grep "${ipadm_property}," "${restore_file}" | cut -f2 -d',' )
          restore_value=$( grep "${ipadm_property}," "${restore_file}" | cut -f3 -d',' )
          restore_check=$( expr "${restore_property}" : "[A-z]" )
          if [ "${restore_check}" = 1 ]; then
            if [ "${current_value}" != "${restore_value}" ]; then
              verbose_message "\"${ipadm_name}\" \"${ipadm_property}\" to \"${restore_value}\"" "restore"
              eval "ipadm set-prop -p ${ipadm_name}=${restore_value} ${ipadm_property}"
            fi
          fi
        fi
      else
        verbose_message "Value of \"${ipadm_name}\" for \"${ipadm_property}\" is \"${correct_value}\""
      fi
      if [ "${current_value}" -ne "${correct_value}" ]; then
        command_line="ipadm set-prop -p ${ipadm_name}=${correct_value} ${ipadm_property}"
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure  "Value of \"${ipadm_name} ${ipadm_property}\" not set to \"${correct_value}\""
          verbose_message     "${command_line}" "fix"
        else
          if [ "${audit_mode}" = 0 ]; then
            verbose_message "Value of \"${ipadm_name} ${ipadm_property}\" to \"${correct_value}\"" "set"
            echo "${ipadm_name},${ipadm_property},${correct_value}" >> "${log_file}"
            eval "${command_line}"
          fi
        fi
      else
        if [ "${audit_mode}" != 2 ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_secure  "Value of \"${ipadm_name} ${ipadm_property}\" already set to \"${correct_value}\""
          fi
        fi
      fi
    fi
  fi
}
