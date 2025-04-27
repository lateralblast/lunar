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
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      verbose_message "Touch ID" "check"
      if [ "${audit_mode}" != 2 ]; then
        check_value=$( sudo bioutil -r -s | grep -E "Touch|Biometric" |grep timeout |cut -f2 -d: |sed "s/ //g" > /dev/null 2>&1 )
        if [ "${check_value}" = "${touchid_timeout}" ]; then
          increment_secure "Touch ID Timeout for system is set to \"${touchid_timeout}\""
        else
          increment_insecure "Touch ID Timeout for system is not set to \"${touchid_timeout}\""
        fi
        user_list=$( find /Users -maxdepth 1 |grep -vE "localized|Shared" |cut -f3 -d/ )
        for user_name in ${user_list}; do
          check_value=$( sudo -u "${user_name}" bioutil -r | grep -E "Touch|Biometric" |grep timeout |cut -f2 -d: |sed "s/ //g" > /dev/null 2>&1 )
          if [ "${check_value}" = "${touchid_timeout}" ]; then
            increment_secure "Touch ID Timeout for user \"${user_name}\" is set to \"${touchid_timeout}\""
          else
            increment_insecure "Touch ID Timeout for for user \"${user_name}\" is not set to \"${touchid_timeout}\""
          fi
        done
      fi
    fi
  fi
}
