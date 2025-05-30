#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_auto_login
#
# Disabling automatic login decreases the likelihood of an unauthorized person gaining
# access to a system.
#
# Refer to Section(s) 5.7       Page(s) 53-54  CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 5.8,6.1.1 Page(s) 152-3  CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 2.12.3    Page(s) 248-50 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_auto_login() {
  print_function "audit_auto_login"
  if [ "${os_name}" = "Darwin" ]; then
    string="Autologin"
    verbose_message         "${string}" "check"
    check_osx_defaults_bool "/Library/Preferences/.GlobalPreferences" "com.apple.userspref.DisableAutoLogin" "yes"
    if [ ! "${audit_mode}" != 2 ]; then
      get_command="defaults read /Library/Preferences/com.apple.loginwindow | grep -c autoLoginUser | sed 's/ //g'"
      set_command="sudo /usr/bin/defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser"
      defaults_check=$( eval "${get_command}" ) 
      if [ "${defaults_check}" = "0" ]; then
        increment_insecure  "${string} Disabled"
      else
        increment_secure    "${string} Enabled"
      fi
      if [ "${ansible_mode}" = 1 ]; then
        ansible_counter=$((ansible_counter+1))
        ansible_value="audit_auto_login_${ansible_counter}"
        echo ""
        echo "- name: Checking ${string}"
        echo "  command: sh -c \"${get_command}\""
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
        lockdown_command="${set_command}"
        lockdown_message="Disable ${string}"
        execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
      fi
    fi
  fi
}