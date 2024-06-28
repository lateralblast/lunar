#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_keychain_lock
#
# Check keychain lock
#
# Refer to Section(s) 5.2   Page(s) 49-50 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(2) 5.4-5 Page(s)       CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_keychain_lock () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Keychain Lock" "check"
    if [ "$audit_mode" != 2 ]; then
      for check_value in "timeout=21600s" lock-on-sleep; do
       verbose_message "Keychain has \"$check_value\" set" "check"
        actual_value=$( security show-keychain-info 2>&1 | grep "$check_value" )
        if [ -z "$actual_value" ]; then
          increment_insecure "Keychain has \"$check_value\" set"
        else
          increment_secure   "Keychain has \"$check_value\" set"
        fi
      done
    fi
  fi
}
