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
        multicast_test=$( grep -c "NoMulticastAdvertisements" "${check_file}" )
        if [ -n "${ansible}" ]; then
          echo ""
          echo "- name: Checking ${string}"
          echo "  command: sh -c \"cat ${check_file} |grep NoMulticastAdvertisements\""
          echo "  register: mcast_check"
          echo "  failed_when: mcast_check == 1"
          echo "  changed_when: false"
          echo "  ignore_errors: true"
          echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
          echo "- name: Fixing ${string}"
          echo "  command: sh -c \"cat ${check_file} |sed 's,mDNSResponder</string>,&X                <string>-NoMulticastAdvertisements</string>,g' | tr X '\n' > ${temp_file} ; cat ${temp_file} > ${check_file}\""
          echo "  when: mcast_check.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
        fi 
        if [ -n "$multicast_test" ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure  "Bonjour Multicast Advertising enabled"
            verbose_message     "sed 's,mDNSResponder</string>,&X                <string>-NoMulticastAdvertisements</string>,g' | < ${check_file} | tr X '\n' > ${temp_file}" "fix"
            verbose_message     "cat ${temp_file} > ${check_file}" "fix"
            verbose_message     "rm ${temp_file}" "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            backup_file "${check_file}"
            sed 's,mDNSResponder</string>,&X                <string>-NoMulticastAdvertisements</string>,g' < "${check_file}" | tr X '\n' > "${temp_file}"
            cat "${temp_file}" > "${check_file}"
            if [ -f "${temp_file}" ]; then
              rm "${temp_file}"
            fi
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
