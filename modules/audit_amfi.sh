#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_amfi
#
# Apple Mobile File Integrity validates that application code is validated.
#
# Refer to Section(s) 5.1.3 Page(s) 303-4 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_amfi () {
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1012 ]; then
      ansible_counter=$((ansible_counter+1))
      ansible_value="audit_amfi_${ansible_counter}"
      string="Apple Mobile File Integrity"
      verbose_message "${string}" "check"
      if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
        verbose_message "Requires sudo to check" "notice"
        return
      fi
      get_command="sh -c \"sudo nvram -p > /dev/null 2>&1 | grep -c amfi | sed 's/ //g'"
      set_command="sudo /usr/sbin/nvram boot-args=\\\"\\\""
      if [ "${audit_mode}" != 2 ]; then
        check_value=$( sudo nvram -p > /dev/null 2>&1 | grep -c amfi | sed "s/ //g" )
        if [ "${check_value}" = "0" ]; then
          increment_secure   "Apple Mobile File Integrity is not \"disabled\""
        else
          increment_insecure "Apple Mobile File Integrity is set to \"${check_value}\""
        fi
        if [ "${ansible}" = 1 ]; then
          echo ""
          echo "- name: Checking ${string}"
          echo "  command: sh -c \"${get_command}'\""
          echo "  register: ${ansible_value}"
          echo "  failed_when: ${ansible_value} != 0"
          echo "  changed_when: false"
          echo "  ignore_errors: true"
          echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
          echo "- name: Fixing ${string}"
          echo "  command: sh -c \"${set_command}\""
          echo "  when: ${ansible_value}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
        else
          lockdown_command="sudo /usr/sbin/nvram boot-args=\"\""
          lockdown_message="Enable ${string}"
          execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
        fi
      fi
    fi
  fi
}
