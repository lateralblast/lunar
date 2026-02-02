#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2028
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_rsa_securid_pam
#
# Check that RSA is installed
#.

audit_rsa_securid_pam () {
  print_function "audit_rsa_securid_pam"
  string="RSA SecurID PAM Agent Configuration"
  check_message "${string}"
  if [ "${os_name}" = "Linux" ] || [ "${os_name}" = "SunOS" ]; then
    check_file="/etc/sd_pam.conf"
    if [ -f "${check_file}" ]; then
      search_string="pam_securid.so"
      if [ "${os_name}" = "SunOS" ]; then
        check_file="/etc/pam.conf"
        if [ -f "${check_file}" ]; then
          command="grep \"${search_string}\" \"${check_file}\" | awk '{print \$3}'"
          command_message "${command}"
          check_value=$( eval "${command}" )
        fi
      fi
      if [ "${os_name}" = "Linux" ]; then
        check_file="/etc/pam.d/sudo"
        if [ -f "${check_file}" ]; then
          command="grep \"${search_string}\" \"${check_file}\" | awk '{print \$4}'"
          command_message "${command}"
          check_value=$( eval "${command}" )
        fi
      fi
      if [ "${audit_mode}" != 2 ]; then
        if [ "${check_value}" != "${search_string}" ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "RSA SecurID PAM Agent is not enabled for sudo"
            if [ "${os_name}" = "Linux" ]; then
              verbose_message "cat ${check_file} |sed 's/^auth/#\&/' > ${temp_file}" "fix"
              verbose_message "cat ${temp_file} > ${check_file}" "fix"
              verbose_message "echo \"auth\trequired\tpam_securid.so reserve\" >> ${check_file}" "fix"
              verbose_message "rm ${temp_file}" "fix"
            fi
            if [ "${os_name}" = "SunOS" ]; then
              verbose_message "echo \"sudo\tauth\trequired\tpam_securid.so reserve\" >> ${check_file}" "fix"
            fi
          fi
          if [ "${audit_mode}" = 0 ]; then
            backup_file     "${check_file}"
            verbose_message "Configuring RSA SecurID PAM Agent for sudo" "set"
            if [ "${os_name}" = "Linux" ]; then
              command="sed 's/^auth/#\\&/' < "${check_file}" > "${temp_file}""
              command_message "${command}"
              file_list=$( eval "${command}" )
              command="cat "${temp_file}" > "${check_file}""
              command_message "${command}"
              file_list=$( eval "${command}" )
              command="echo \"auth\trequired\tpam_securid.so reserve\" >> "${check_file}""
              command_message "${command}"
              file_list=$( eval "${command}" )
              if [ -f "${temp_file}" ]; then
                rm "${temp_file}"
              fi
            fi
            if [ "${os_name}" = "SunOS" ]; then
              echo "sudo\tauth\trequired\tpam_securid.so reserve" >> "${check_file}"
            fi
            #echo "Removing:  Configuring logrotate"
            #cat ${check_file} |sed 's,.*{,${search_string} {,' > ${temp_file}
            #cat ${temp_file} > ${check_file}
            #rm ${temp_file}
          fi
        else
          if [ "${audit_mode}" = 1 ]; then
            increment_secure "RSA SecurID PAM Agent is configured for sudo"
          fi
        fi
      else
        restore_file "${check_file}" "${restore_dir}"
      fi
    fi
  else
    na_message "${string}"
  fi
}
