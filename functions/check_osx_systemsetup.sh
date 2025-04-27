#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_osx_systemsetup
#
# Function to systemsetup output under OS X
#.

check_osx_systemsetup () {
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${os_version}" -ge 12 ]; then
      param="$1"
      value="$2"
      backup_file="systemsetup_${param}"
      if [ "${audit_mode}" != 2 ]; then
        string="Parameter \"${param}\" is set to \"${value}\""
        verbose_message "${string}" "check"
        if [ "${ansible}" = 1 ]; then
          echo ""
          echo "- name: Checking ${string}"
          echo "  command: sh -c \"sudo systemsetup -${param} |cut -f2 -d: |sed 's/ //g' |tr '[:upper:]' '[:lower:]'\""
          echo "  register: systemsetup_check"
          echo "  failed_when: systemsetup_check == 1"
          echo "  changed_when: false"
          echo "  ignore_errors: true"
          echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
          echo "- name: Fixing ${string}"
          echo "  command: sudo systemsetup -${param} ${value}"
          echo "  when: systemsetup_check.rc == 0 and ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
        fi
        check=$( eval "sudo systemsetup -${param} | cut -f2 -d: | sed 's/ //g' | tr '[:upper:]' '[:lower:]'" )
        if [ "${check}" != "${value}" ]; then
          backup_file="${work_dir}/${backup_file}"
          increment_insecure "Parameter \"${param}\" not set to \"${value}\""
          lockdown_command   "echo \"$check\" > ${backup_file} ; sudo systemsetup -${param} ${value}" "Parameter \"${param}\" to \"${value}\""
        else
          increment_secure   "Parameter \"${param}\" is set to \"${value}\""
        fi
      else
        restore_file="${restore_dir}/${backup_file}"
        if [ -f "${restore_file}" ]; then
          now=$( eval "sudo systemsetup -${param} | cut -f2 -d: | sed 's/ //g' | tr '[:upper:]' '[:lower:]'" )
          old=$( cat "${restore_file}" )
          if [ "${now}" != "${old}" ]; then
            verbose_message "Parameter \"${param}\" back to \"${old}\"" "set"
            eval "sudo systemsetup -${param} ${old}"
          fi
        fi
      fi
    fi
  fi
}
