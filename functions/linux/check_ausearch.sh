#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_ausearch
#
# Check what the auditing entries are for a specific command
#.

check_ausearch () {
  print_function "check_ausearch"
  if [ "${os_name}" = "Linux" ]; then
    if [ "${audit_mode}" != 2 ]; then
      funct="$1"
      bin="$2"
      command="$3"
      mode="$4"
      value="$5" 
      exists=$( command -v "${bin}" )
      if [ "${exists}" ]; then
        if [ "${value}" ]; then
          check=$( ausearch -k "${bin}" 2> /dev/null | grep "${command}" | grep "${mode}" | grep "${value}" )
          secure_string="Binary \"${bin}\" has commands \"${command}\" with option \"${mode}\" is set to \"${value}\""
          insecure_string="Binary \"${bin}\" has commands \"${command}\" with option \"${mode}\" is not set to \"${value}\""
        else
          check=$( ausearch -k "${bin}" 2> /dev/null | grep "${command}" | grep "${mode}" )
          secure_string="Binary \"${bin}\" has commands \"${command}\" with option \"${mode}\" is set"
          insecure_string="Binary \"${bin}\" has commands \"${command}\" with option \"${mode}\" is unset"
        fi
        verbose_message "${secure_string}" "check"
        if [ "${ansible_mode}" = 1 ]; then
          echo ""
          echo "- name: Checking ${secure_string}"
          echo "  file:"
          echo "    path: ${check_file}"
          echo "    mode: ${check_perms}"
          echo ""
        fi
        if [ "$funct" = "equal" ]; then
          if [ "${value}" ]; then
            if [ -z "${check}" ]; then
              increment_insecure "${insecure_string}"
            else
              increment_secure   "${secure_string}"
            fi
          else
            if [ "${check}" ]; then
              increment_insecure "${insecure_string}"
            else
              increment_secure   "${secure_string}"
            fi
          fi
        else
          if [ "${value}" ]; then
            if [ "${check}" ]; then
              increment_insecure "${insecure_string}"
            else
              increment_secure   "${secure_string}"
            fi
          else
            if [ -z "${check}" ]; then
              increment_insecure "${insecure_string}"
            else
              increment_secure   "${secure_string}"
            fi
          fi
        fi
      fi
    fi
  fi
}
