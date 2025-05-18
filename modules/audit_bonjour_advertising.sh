#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154
# shellcheck disable=SC2028

# audit_bonjour_advertising
#
# Refer to Section(s) 3.4-7     Page(s) 39-40 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 2.4.14.14 Page(s) 62-3  CIS Apple OS X 10.5 Benchmark v1.1.0
# Refer to Section(s) 4.1       Page(s) 96-7  CIS Apple OS X 10.5 Benchmark v1.1.0
# Refer to Section(s) 4.1       Page(s) 290-1 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_bonjour_advertising() {
  if [ "${os_name}" = "Darwin" ]; then
    check_file="/System/Library/LaunchDaemons/com.apple.mDNSResponder.plist"
    if [ "${long_os_version}" -ge 1014 ]; then
      check_osx_defaults_bool "/Library/Preferences/com.apple.mDNSResponder.plist" "NoMulticastAdvertisements" "1"
    else
      verbose_message "Bonjour Multicast Advertising" "check"
      temp_file="${temp_dir}/mdnsmcast"
      if [ "${audit_mode}" = 2 ]; then
        restore_file "${check_file}" "${restore_dir}"
      else
        get_command="cat ${check_file} |grep NoMulticastAdvertisements"
        set_command="sed 's,mDNSResponder</string>,&X                <string>-NoMulticastAdvertisements</string>,g' < ${check_file} | tr X '\n' > ${temp_file} ; cat ${temp_file} > ${check_file} ; rm ${temp_file}"
        multicast_test=$( grep -c "NoMulticastAdvertisements" "${check_file}" )
        if [ -n "${ansible}" ]; then
          ansible_counter=$((ansible_counter+1))
          ansible_value="audit_bonjour_advertising_${ansible_counter}"
          echo ""
          echo "- name: Checking ${string}"
          echo "  command: sh -c \"${get_command}\""
          echo "  register: ${ansible_value}"
          echo "  failed_when: ${ansible_value} == 1"
          echo "  changed_when: false"
          echo "  ignore_errors: true"
          echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
          echo "- name: Fixing ${string}"
          echo "  command: sh -c \"${set_command}\""
          echo "  when: ${ansible_value}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
        fi 
        if [ -n "$multicast_test" ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure  "Bonjour Multicast Advertising enabled"
            verbose_message     "${set_command}" "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            backup_file "${check_file}"
            lockdown_message="Bonjour Multicast Advertising disabled"
            lockdown_command="${set_command}"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          fi
        else
          if [ "${audit_mode}" = 1 ]; then
            increment_secure    "Bonjour Multicast Advertising disabled"
          fi
        fi
      fi
    fi
    if [ "$osx_mdns_enable" != "yes" ]; then
      check_launchctl_service   "com.apple.mDNSResponder"       "off"
      check_launchctl_service   "com.apple.mDNSResponderHelper" "off"
    fi
  fi
}
