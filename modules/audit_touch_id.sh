#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_touch_id
#
# Touch ID allows for an account-enrolled fingerprint to access a key that uses a
# previously provided password.
#
# Refer to Section(s) 2.11.2 Page(s) 237-40 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_touch_id () {
  print_module "audit_touch_id"
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      string="Touch ID"
      verbose_message "${string}" "check"
      if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
        verbose_message "Requires sudo to check" "notice"
        return
      fi
      if [ "${audit_mode}" != 2 ]; then
        get_command="sudo bioutil -r -s | grep timeout | head -1 | cut -f2 -d: | grep -c ${touchid_timeout} | sed 's/ //g'"
        set_command="/usr/bin/sudo usr/bin/bioutil -w -s -o ${touchid_timeout}"
        check_value=$( eval "${get_command}" )
        if [ "${check_value}" = "${touchid_timeout}" ]; then
          increment_secure   "Touch ID Timeout for system is set to \"${touchid_timeout}\""
        else
          increment_insecure "Touch ID Timeout for system is not set to \"${touchid_timeout}\""
        fi
        if [ "${ansible}" = 1 ]; then
          ansible_counter=$((ansible_counter+1))
          ansible_value="audit_touch_id_${ansible_counter}"
          echo ""
          echo "- name: Checking ${string}"
          echo "  command: sh -c \"${get_command}\""
          echo "  register: ${ansible_value}"
          echo "  failed_when: ${ansible_value} != 1"
          echo "  changed_when: false"
          echo "  ignore_errors: true"
          echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
          echo "- name: Fixing ${string}"
          echo "  command: sh -c \"${set_command}\""
          echo "  when: ${ansible_value}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
        else
          lockdown_command="${set_command}" 
          lockdown_message="${string}"
          execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
        fi
        for item in unlock ApplePay ; do
          string="Touch ID ${item}"
          verbose_message "${string}" "check"
          user_list=$( find /Users -maxdepth 1 | grep -vE "localized|Shared" | cut -f3 -d/ )
          for user_name in ${user_list}; do
            check_value=$( sudo -u "${user_name}" bioutil -r -s | grep "${item}" | head -1 | cut -f2 -d: | sed "s/ //g" > /dev/null 2>&1 )
            if [ "${check_value}" = "${touchid_timeout}" ]; then
              increment_secure   "Touch ID Timeout for user \"${user_name}\" is set to \"${touchid_timeout}\""
            else
              increment_insecure "Touch ID Timeout for for user \"${user_name}\" is not set to \"${touchid_timeout}\""
            fi
            if [ "${ansible}" = 1 ]; then
              echo ""
              echo "- name: Checking ${string} for ${user_name}"
              echo "  command: sh -c \"sudo -u ${user_name} bioutil -r -s | grep ${item} | head -1 | cut -f2 -d: | sed 's/ //g'\""
              echo "  register: audit_touch_id_check"
              echo "  failed_when: audit_touch_id_check != 1"
              echo "  changed_when: false"
              echo "  ignore_errors: true"
              echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
              echo ""
              echo "- name: Fixing ${string}"
              if [ "${item}" = "unlock" ]; then
                echo "  command: sh -c \"/usr/bin/sudo usr/bin/bioutil -w -u 1\""
              else
                echo "  command: sh -c \"/usr/bin/sudo usr/bin/bioutil -w -a 1\""
              fi
              echo "  when: audit_touch_id_check.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
              echo ""
            else
              if [ "${item}" = "unlock" ]; then
                lockdown_command="/usr/bin/sudo usr/bin/bioutil -w -u 1"
              else
                lockdown_command="/usr/bin/sudo usr/bin/bioutil -w -s 1"
              fi
            fi
            lockdown_message="${string}"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          done
        done
      fi
    fi
  fi
}
