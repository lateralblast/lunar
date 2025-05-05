#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2012
# shellcheck disable=SC2028
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_file_comment
#
# Check if a file contains a value and comment it out
#
#.

check_file_comment () {
  file="$1"
  search="$2"
  comment="$3"
  line="^(\s*${search}.*)"
  if [ "${comment}" = "hash" ]; then
    comment="#"
  fi
  string="File ${file} with line containing ${search} is commented out"
  verbose_message "${string}" "check"
  if [ "${audit_mode}" != 2 ]; then
    if [ -f "${file}" ]; then
      check=$( grep "${search}" < "${file}" | grep -cv "^${comment}" )
      if [ ! "${check}" = "0" ]; then
        if [ "${ansible}" = 1 ]; then
          echo ""
          echo "- name: Checking ${string}"
          echo "  lineinfile:"
          echo "    path: ${check_file}"
          echo "    line: '${line}'"
          echo "    replace: '#\1'"
          echo "    create: yes"
          echo ""
        else
          lockdown_command "sed 's/${line}/${comment}\1/g' < ${check_file} > ${temp_file} ; cat ${temp_file} > ${check_file}"
        fi
        if [ "${audit_mode}" = 0 ]; then
          backup_file     "${check_file}"
          verbose_message "File \"${check_file}\"" "update"
          echo "${check_file},sed" >> "${log_file}"
          sed  "s/${line}/${comment}\1/g" < "${check_file}" > "${temp_file}"
          cat  "${temp_file}" > "${check_file}"
        fi
      fi
    fi
  fi
  if [ "${audit_mode}" = 2 ]; then
    restore_file "${check_file}" "${restore_dir}"
  fi
}
