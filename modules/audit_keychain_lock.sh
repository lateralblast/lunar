#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_keychain_lock
#
# Check keychain lock
#
# Refer to Section(s) 5.2 Page(s) 49-50 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(2) 5.5 Page(s) 164-5 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_keychain_lock () {
  print_module "audit_keychain_lock"
  if [ "${os_name}" = "Darwin" ]; then
    string="Keychain Lock"
    timeout="21600"
    verbose_message "${string}" "check"
    if [ "${audit_mode}" != 2 ]; then
      for check_value in timeout lock-on-sleep; do
       verbose_message "Keychain has \"${check_value}\" set" "check"
        actual_value=$( security show-keychain-info 2> /dev/null | grep "${check_value}" | grep -c "${timeout}" | sed "s/ //g" )
        if [ "${actual_value}" = "0" ]; then
          increment_insecure "Keychain \"${check_value}\" does not have \"${timeout}\" set"
        else
          increment_secure   "Keychain \"${check_value}\" has \"${timeout}\" set"
        fi
        if [ "${ansible}" = 1 ]; then
          ansible_counter=$((ansible_counter+1))
          ansible_value="audit_keychain_lock_${ansible_counter}"
          echo ""
          echo "- name: Checking ${string}"
          echo "  command: sh -c \"security show-keychain-info 2> /dev/null | grep '${check_value}' | grep -c '${timeout}' | sed 's/ //g'\""
          echo "  register: ${ansible_value}"
          echo "  failed_when: ${ansible_value} != 0"
          echo "  changed_when: false"
          echo "  ignore_errors: true"
          echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
          echo "- name: Fixing ${string}"
          if [ "${check_value}" = "timeout" ]; then
            echo "  command: sh -c \"set-keychain-settings -u -t ${timeout}\""
          else
            echo "  command: sh -c \"set-keychain-settings -l -t ${timeout}\""
          fi
          echo "  when: ${ansible_value}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
        else
          execute_lockdown "sudo /usr/bin/security authorizationdb write system.login.screensaver use-login-window-ui" "Disable ${string}"
        fi
      done
    fi
  fi
}
