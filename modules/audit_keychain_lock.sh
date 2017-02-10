# audit_keychain_lock
#
# Refer to Section 5.2 Page(s) 49-50 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_keychain_lock() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Keychain Lock"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Keychain Lock time is set"
      actual_value=`security show-keychain-info 2>&1 |awk '{print $3}'`
      if [ "$actual_value" = "no-timeout" ]; then
        if [ "$audit_mode" = 1 ]; then
          
          
          increment_insecure "Keychain Lock time is not set"
        fi
        if [ "$audit_mode" = 1 ] || [ "$audit_mode" = 0 ]; then
          verbose_message "" fix
          verbose_message "Select Keychain Access" fix
          verbose_message "Select a keychain" fix
          verbose_message "Select Edit" fix
          verbose_message "Select Change Settings for keychain <keychain_name>" fix
          verbose_message "Authenticate, if requested." fix
          verbose_message "Change the Lock after # minutes of inactivity setting for the Login Keychain to 15" fix
          verbose_message "" fix
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          
          
          increment_secure "Keychain Lock time is set"
        fi
      fi
    else
      verbose_message "" fix
      verbose_message "Select Keychain Access" fix
      verbose_message "Select a keychain" fix
      verbose_message "Select Edit" fix
      verbose_message "Select Change Settings for keychain <keychain_name>" fix
      verbose_message "Authenticate, if requested." fix
      verbose_message "Change the Lock after # minutes of inactivity setting for the Login Keychain to 15" fix
      verbose_message "" fix
    fi
  fi
}
