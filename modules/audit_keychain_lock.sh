# audit_keychain_lock
#
# Refer to Section 5.2   Page(s) 49-50 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section 5.4-5 Page(s) 1verbose_message "-3 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_keychain_lock() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Keychain Lock"
    if [ "$audit_mode" != 2 ]; then
      for check_value in "timeout=21600s" lock-on-sleep; do
       verbose_message "Keychain has $check_value set"
        actual_value=$( security show-keychain-info 2>&1 | grep "$check_value" )
        if [ ! "$actual_value" ]; then
          increment_insecure "Keychain has $check_value set"
        else
          increment_secure "Keychain has $check_value set"
        fi
      done
    fi
  fi
}
