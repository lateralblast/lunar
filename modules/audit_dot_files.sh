#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_dot_files
#
# Check for a dot file and copy it to backup directory
#.

audit_dot_files () {
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    verbose_message "Dot Files" "check"
    check_file="$1"
    if [ "${audit_mode}" != 2 ]; then
      dir_list=$( cut -f6 -d':' /etc/passwd )
      for dir_name in ${dir_list}; do
        if [ "${dir_name}" = "/" ]; then
          dot_file="/${check_file}"
        else
          dot_file="${dir_name}/${check_file}"
        fi
        if [ -f "${dot_file}" ]; then
          if [ "${audit_mode}" = 1 ];then
            increment_insecure "File \"${dot_file}\" ${exists}"
            verbose_message    "mv ${dot_file} ${dot_file}.disabled" "fix"
          fi
          if [ "${audit_mode}" = 0 ];then
            backup_file "${dot_file}"
          fi
        else
          if [ "${audit_mode}" = 1 ];then
            increment_secure "File \"${dot_file}\" does not exist"
          fi
        fi
      done
    else
      file_list=$( find "${restore_dir}" -name "${check_file}" )
      for check_file in ${file_list}; do
        restore_file "${check_file}" "${restore_dir}"
      done
    fi
  fi
}
