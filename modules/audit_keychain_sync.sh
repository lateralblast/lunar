#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_keychain_sync
#
# Ensure that the iCloud keychain is used consistently with organizational requirements.
#
# Refer to ection(s) 2.1.1.1 Page(s) 41-44 CIS macOS 14 Sonoma Benchmark v1.0.0
#.

audit_keychain_sync () {
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      verbose_message "Keychain sync" "check"
      if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
        verbose_message "Requires sudo to check" "notice"
        return
      fi
      if [ "${audit_mode}" != 2 ]; then
        user_list=$( find /Users -maxdepth 1 | grep -vE "localized|Shared" | cut -f3 -d/ | grep "[a-z]")
        for user_name in ${user_list}; do
          check_value=$( eval  "sudo -u ${user_name} defaults read /Users/${user_name}/Library/Preferences/MobileMeAccounts 2> /dev/null |grep -B 1 KEYCHAIN_SYNC |head -1 |cut -f2 -d= |cut -f1 -d\; |sed 's/ //g'" )
          if [ "${check_value}" = "${keychain_sync}" ]; then
            increment_secure   "Keychain sync enable for \"${user_name}\" is set to \"${keychain_sync}\""
          else
            increment_insecure "Keychain sync enable for \"${user_name}\" is not set to \"${keychain_sync}\""
          fi
        done
      fi
    fi
  fi
}
