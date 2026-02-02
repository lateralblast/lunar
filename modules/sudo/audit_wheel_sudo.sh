#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2028
# shellcheck disable=SC2154

# audit_wheel_sudo
#
# Check wheel group settings in sudoers
#.

audit_wheel_sudo () {
  print_function "audit_wheel_sudo"
  string="Sudoers group settings"
  check_message "${string}"
  temp_file="${temp_dir}/audit_wheel_sudo"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "Darwin" ]; then
    for check_dir in /etc /usr/local/etc /usr/sfw/etc /opt/csw/etc; do
      check_dir="${check_dir}/sudoers.d"
      if [ -d "${check_dir}" ]; then
        check_files=$( find "${check_dir}" -type f )
        for check_file in ${check_file}s; do
          check_file_perms "${check_file}" "0440" "root" "root"
          if [ "${audit_mode}" != 2 ]; then
            wheel_groups=$( grep NOPASSWD "${check_file}" | grep ALL | grep -v '^#' | awk '{print $1}' )
            for wheel_group in ${wheel_groups} ; do
              if [ "${ansible_mode}" = 1 ]; then
                echo ""
                echo "- name: Checking NOPASSWD for ${wheel_group} in ${check_file}"
                echo "  lineinfile:"
                echo "    path: ${check_file}"
                echo "    regexp: ''(.*NOPASSWD.*)'"
                echo "    replace: '#\1'"
                echo ""
              fi
              lockdown_command="sed 's/^\(%.*NOPASSWD.*\)/#\1/g' < ${check_file} > ${temp_file} ; cat ${temp_file} > ${check_file}"
              lockdown_message="Disabling group \"${wheel_group}\" NOPASSWD entry"
              if [ "${audit_mode}" = 1 ]; then
                increment_insecure "Group ${wheel_group} does not require password to escalate privileges"
                execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
              fi
              if [ "${audit_mode}" = 0 ]; then
                backup_file      "${check_file}"
                execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
              fi
            done
          else
            restore_file "${check_file}" "${restore_dir}"
          fi
        done
      fi
      check_file="${check_dir}/sudoers"
      if [ -f "${check_file}" ]; then
        check_file_perms ${check_file} 0440 root root
        if [ "${audit_mode}" != 2 ]; then
          wheel_groups=$( grep NOPASSWD "${check_file}" | grep ALL | grep -v '^#' | awk '{print $1}' )
          for wheel_group in ${wheel_groups} ; do
            if [ "${ansible_mode}" = 1 ]; then
              echo ""
              echo "- name: Checking NOPASSWD for ${wheel_group} in ${check_file}"
              echo "  lineinfile:"
              echo "    path: ${check_file}"
              echo "    regexp: ''(.*NOPASSWD.*)'"
              echo "    replace: '#\1'"
              echo ""
            fi
            lockdown_command="sed 's/^\(%.*NOPASSWD.*\)/#\1/g' < ${check_file} > ${temp_file} ; cat ${temp_file} > ${check_file}"
            lockdown_message="Disabling group \"${wheel_group}\" NOPASSWD entry"
            if [ "${audit_mode}" = 1 ]; then
              increment_insecure "Group \"${wheel_group}\" does not require password to escalate privileges"
              execute_lockdown   "${lockdown_command}" "${lockdown_message}" "sudo"
            fi
            if [ "${audit_mode}" = 0 ]; then
              backup_file      "${check_file}"
              execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
            fi
          done
        else
          restore_file "${check_file}" "${restore_dir}"
        fi
      fi
    done
  else
    na_message "${string}"
  fi
}
