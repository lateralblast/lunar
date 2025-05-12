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
      name="audit_amfi_${ansible_counter}"
      string="Apple Mobile File Integrity"
      verbose_message "${string}" "check"
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
          echo "  command: sh -c \"sudo nvram -p > /dev/null 2>&1 | grep -c amfi | sed 's/ //g'\""
          echo "  register: ${name}"
          echo "  failed_when: ${name} != 0"
          echo "  changed_when: false"
          echo "  ignore_errors: true"
          echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
          echo "- name: Fixing ${string}"
          echo "  command: sh -c \"sudo /usr/sbin/nvram boot-args=\\\"\\\"\""
          echo "  when: ${name}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
        else
          execute_lockdown "sudo /usr/sbin/nvram boot-args=\"\"" "Enable ${string}"
        fi
      fi
    fi
  fi
}
