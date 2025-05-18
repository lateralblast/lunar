#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_pam_gdm_autologin
#
# Check PAM GDM autologin settings
#
# Refer to Section(s) 16.11 Page(s) 54-5 Solaris 11.1 Benchmark v1.0.0
#.

audit_pam_gdm_autologin () {
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "11" ]; then
      pam_module="gdm-autologin"
      check_string="Gnome Autologin"
      verbose_message "${check_string}" "check"
      check_file="/etc/pam.d/${pam_module}"
      temp_file="${temp_dir}/${pam_module}"
      if [ "${audit_mode}" = 2 ]; then
        restore_file "${check_file}" "${restore_dir}"
      fi
      if [ "${audit_mode}" != 2 ]; then
        if [ "${ansible}" = 1 ]; then
          ansible_counter=$((ansible_counter+1))
          ansible_value="audit_pam_gdm_autologin_${ansible_counter}"
          echo ""
          echo "- name: Checking ${check_string}"
          echo "  command:  sh -c \"cat ${check_file} |grep -v '^#' |grep '^${pam_module}' |head -1 |wc -l\""
          echo "  register: ${ansible_value}"
          echo "  failed_when: ${ansible_value} == 1"
          echo "  changed_when: false"
          echo "  ignore_errors: true"
          echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
          echo "- name: Fixing ${check_string}"
          echo "  command: sh -c \"sed -i 's/^${pam_module}/#&/g' ${check_file}\""
          echo "  when: ${ansible_value} .rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
        fi
        gdm_check=$( grep -v "^#" "${check_file}" | grep "^${pam_module}" | head -1 | wc -l | sed "s/ //g" )
        if [ "${gdm_check}" != 0 ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "${check_string} is enabled"
            verbose_message    "cat ${check_file} |sed 's/^${pam_module}/#&/g' > ${temp_file}" "fix"
            verbose_message    "cat ${temp_file} > ${check_file}" "fix"
            verbose_message    "rm ${temp_file}" "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            backup_file "${check_file}"
            sed "s/^${pam_module}/#&/g" "${check_file}" > "${temp_file}"
            cat "${temp_file}" > "${check_file}"
            if [ -f "${temp_file}" ]; then
              rm "${temp_file}"
            fi
          fi
        else
          if [ "${audit_mode}" = 1 ];then
            increment_secure "${check_string} is disabled"
          fi
        fi
      fi
    fi
  fi
}
