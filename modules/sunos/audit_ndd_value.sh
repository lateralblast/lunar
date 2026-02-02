#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ndd_value
#
# Modify Network Parameters
# Checks and sets ndd values
#.

audit_ndd_value () {
  print_function "audit_ndd_value"
  string="NDD Value"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      ndd_name="${1}"
      ndd_property="${2}"
      correct_value="${3}"
      if [ "${ndd_property}" = "tcp_extra_priv_ports_add" ]; then
        command="ndd -get \"${ndd_name}\" tcp_extra_priv_ports | grep \"${correct_value}\""
        command_message "${command}"
        current_value=$( eval "${command}" )
      else
        command="ndd -get \"${ndd_name}\" \"${ndd_property}\""
        command_message "${command}"
        current_value=$( eval "${command}" )
      fi
      file_header="ndd"
      log_file="${work_dir}/${file_header}.log"
      if [ "${audit_mode}" = 2 ]; then
        restore_file="${restore_dir}/${file_header}.log"
        if [ -f "${restore_file}" ]; then
          restore_property=$( grep "${ndd_property}," "${restore_file}" | cut -f2 -d',' )
          restore_value=$( grep "${ndd_property}," "${restore_file}" | cut -f3 -d',' )
          if [ -n "${restore_value}"  ]; then
            if [ "${ndd_property}" = "tcp_extra_priv_ports_add" ]; then
              command="ndd -get \"${ndd_name}\" tcp_extra_priv_ports | grep \"${restore_value}\""
              command_message "${command}"
              current_value=$( eval "${command}" )
            fi
            if [ -n "${current_value}" ]; then
              if [ "${current_value}" != "${restore_value}" ]; then
                if [ "${ndd_property}" = "tcp_extra_priv_ports_add" ]; then
                  ndd_property="tcp_extra_priv_ports_del"
                fi
                verbose_message "Restoring: \"${ndd_name}\" \"${ndd_property}\" to \"${restore_value}\"" "restore"
                command="ndd -set \"${ndd_name}\" \"${ndd_property}\" \"${restore_value}\""
                command_message "${command}"
                eval "${command}"
              fi
            fi
          fi
        fi
      else
        verbose_message "NDD ${ndd_name} ${ndd_property}"
      fi
      if [ "${current_value}" -ne "${correct_value}" ]; then
        command_line="ndd -set ${ndd_name} ${ndd_property} ${correct_value}"
        command_message "${command_line}"
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure "NDD \"${ndd_name} ${ndd_property}\" not set to \"${correct_value}\""
          verbose_message "${command_line}" "fix"
        else
          if [ "${audit_mode}" = 0 ]; then
            verbose_message "NDD \"${ndd_name} ${ndd_property}\" to \"${correct_value}\"" "set"
            echo "${ndd_name},${ndd_property},${correct_value}" >> "${log_file}"
            eval "${command_line}"
          fi
        fi
      else
        if [ "${audit_mode}" != 2 ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_secure "NDD \"${ndd_name} ${ndd_property}\" already set to \"${correct_value}\""
          fi
        fi
      fi
    fi
  else
    na_message "${string}"
  fi
}
