#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_pam_wheel
#
# PAM Wheel group membership. Make sure wheel group membership is required to su.
#
# Refer to Section(s) 6.5   Page(s) 142-3 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.5   Page(s) 165-6 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 6.5   Page(s) 145-6 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 5.6   Page(s) 257-8 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 9.5   Page(s) 135-6 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 5.5   Page(s) 235-6 CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 5.6   Page(s) 249   CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 5.2.7 Page(s) 594-5 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_pam_wheel () {
  if [ "${os_name}" = "Linux" ]; then
    pam_module="pam_wheel"
    check_string="PAM ${pam_module} Configuration"
    verbose_message "${check_string}" "check"
    check_file="/etc/pam.d/su"
    if [ -f "${check_file}" ]; then
      search_string="use_uid"
      if [ "${audit_mode}" != 2 ]; then
        check_value=$( grep "^auth" "${check_file}" | grep "${search_string}$" | awk '{print $8}' )
        if [ "${ansible}" = 1 ]; then
          ansible_counter=$((ansible_counter+1))
          ansible_value="audit_pam_wheel_${ansible_counter}"
          echo ""
          echo "- name: Checking ${check_string}"
          echo "  command:  sh -c \"cat ${check_file} | grep -v '^#' |grep '${search_string}$' |head -1 |wc -l\""
          echo "  register: ${ansible_value}"
          echo "  failed_when: ${ansible_value} == 1"
          echo "  changed_when: false"
          echo "  ignore_errors: true"
          echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
          echo "- name: Fixing ${check_string}"
          echo "  command: sh -c \"sed -i 's/^.*${search_string}$/#&/' ${check_file}\""
          echo "  when: ${ansible_value}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
        fi
        if [ "${check_value}" != "${search_string}" ]; then
          if [ "${audit_mode}" = "1" ]; then
            increment_insecure "Wheel group membership not required for su in \"${check_file}\""
            verbose_message    "cp ${check_file} ${temp_file}" "fix"
            verbose_message    "cat ${temp_file} |awk '( \$1==\"#auth\" && \$2==\"required\" && \$3~\"${pam_module}.so\" ) { print \"auth\t\trequired\t\",\$3,\"\tuse_uid\"; next }; { print }' > ${check_file}" "fix"
            verbose_message    "rm ${temp_file}" "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            backup_file     "${check_file}"
            verbose_message "Setting:   Su to require wheel group membership in PAM in \"${check_file}\""
            cp "${check_file}" "${temp_file}"
            awk '( $1=="#auth" && $2=="required" && $3~"${pam_module}.so" ) { print "auth\t\trequired\t",$3,"\tuse_uid"; next }; { print }' < "${temp_file}" > ${check_file}
            if [ -f "$tuse_file" ]; then
              rm "${temp_file}"
            fi
          fi
        else
          if [ "${audit_mode}" = "1" ]; then
            increment_secure "Wheel group membership required for su in \"${check_file}\""
          fi
        fi
      else
        restore_file "${check_file}" "${restore_dir}"
      fi
    fi
  fi
}
