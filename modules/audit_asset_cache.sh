#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_asset_cache
#
# The main use case for Mac computers is as mobile user endpoints. P2P sharing
# services should not be enabled on laptops that are using untrusted networks. Content
# Caching can allow a computer to be a server for local nodes on an untrusted network.
# While there are certainly logical controls that could be used to mitigate risk, they add to
# the management complexity. Since the value of the service is in specific use cases,
#
# Refer to Section(s) 2.3.3.9 Page(s) 111-3 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_asset_cache () {
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1013 ]; then
      ansible_counter=$((ansible_counter+1))
      name="audit_asset_cache_${ansible_counter}"
      string="Asset Cache Activation"
      verbose_message "${string}" "check"
      if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
        verbose_message "Requires sudo to check" "notice"
        return
      fi
      if [ "${audit_mode}" != 2 ]; then
        get_command="sudo AssetCacheManagerUtil status 2>&1 | grep Activated | awk '{print \$2}' | grep -ci false | sed 's/ //g'"
        set_command="sudo /usr/bin/AssetCacheManagerUtil deactivate"
        check_value=$( eval "${get_command}" )
        if [ "${check_value}" = "0" ]; then
          increment_secure   "Content Caching is not activated"
        else
          increment_insecure "Content Caching is activated"
        fi
        if [ "${ansible}" = 1 ]; then
          echo ""
          echo "- name: Checking ${string}"
          echo "  command: sh -c \"${get_command}\""
          echo "  register: ${name}"
          echo "  failed_when: ${name} != 0"
          echo "  changed_when: false"
          echo "  ignore_errors: true"
          echo "  when: ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
          echo "- name: Fixing ${string}"
          echo "  command: sh -c \"${set_command}\""
          echo "  when: ${name}.rc == 1 and ansible_facts['ansible_system'] == '${os_name}'"
          echo ""
        else
          lockdown_command="${set_command}"
          lockdown_message="Disable ${string}"
          execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
        fi
      fi
    fi
  fi
}
