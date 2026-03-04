#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_append_file
#
# Code to append a file with a line
#
# check_file      = The name of the original file
# parameter       = The parameter/line to add to a file
# comment_value   = The character used in the file to distinguish a line as a comment
#.

check_append_file () {
  check_file="${1}"
  parameter="${2}"
  comment_value="${3}"
  print_function "check_append_file"
  dir_name=$( dirname "${check_file}" )
  if [ ! -f "${check_file}" ]; then
    warn_message "File \"${check_file}\" does not exist"
  fi
  if [ ! -d "${dir_name}" ]; then
    warn_message "Directory \"${dir_name}\" does not exist"
  else
    if [ "${comment_value}" = "star" ]; then
      comment_value="*"
    else
      comment_value="#"
    fi
    if [ "${audit_mode}" = 2 ]; then
      restore_file="${restore_dir}${check_file}"
      restore_file "${check_file}" "${restore_dir}"
    else
      secure_string="Parameter \"${parameter}\" is set in \"${check_file}\""
      insecure_string="Parameter \"${parameter}\" is not set in \"${check_file}\""
      check_message "${secure_string}"
      if [ ! -f "${check_file}" ]; then
        inc_insecure     "Parameter \"${parameter}\" does not exist in \"${check_file}\""
        lockdown_command="echo \"${parameter}\" >> ${check_file}"
        lockdown_message="Parameter \"${parameter}\" in \"${check_file}\""
        exec_lockdown    "${lockdown_command}" "${lockdown_message}" "sudo"
        if [ "${parameter}" ]; then
          if [ "${ansible_mode}" = 1 ]; then
            echo ""
            echo "- name: Checking ${secure_string}"
            echo "  lineinfile:"
            echo "    path: ${check_file}"
            echo "    line: '${parameter}'"
            echo "    create: yes"
            echo ""
          fi
        fi
      else
        if [ "${parameter}" ]; then
          if [ "${ansible_mode}" = 1 ]; then
            echo ""
            echo "- name: Checking ${secure_string}"
            echo "  lineinfile:"
            echo "    path: ${check_file}"
            echo "    line: '${parameter}'"
            echo ""
          fi
          command="grep -v \"^${comment_value}\" \"${check_file}\" | grep -- \"${parameter}\" | uniq | wc -l | sed \"s/ //g\""
          command_message     "${command}"
          check_value=$( eval "${command}" )
          if [ "${check_value}" != "1" ]; then
            inc_insecure     "${insecure_string}"
            backup_file      "${check_file}"
            lockdown_command="echo \"${parameter}\" >> ${check_file}"
            lockdown_message="Parameter \"${parameter}\" in \"${check_file}\""
            exec_lockdown    "${lockdown_command}" "${lockdown_message}" "sudo"
          else
            inc_secure       "${secure_string}"
          fi
        fi
      fi
    fi
  fi
}
