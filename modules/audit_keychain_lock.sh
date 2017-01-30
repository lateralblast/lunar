# audit_keychain_lock
#
# Refer to Section 5.2 Page(s) 49-50 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_keychain_lock() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Keychain Lock"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Keychain Lock time is set"
      actual_value=`security show-keychain-info 2>&1 |awk '{print $3}'`
      if [ "$actual_value" = "no-timeout" ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          insecure=`expr $insecure + 1`
          echo "Warning:   Keychain Lock time is not set [$insecure Warnings]"
        fi
        if [ "$audit_mode" = 1 ] || [ "$audit_mode" = 0 ]; then
          funct_verbose_message "" fix
          funct_verbose_message "Select Keychain Access" fix
          funct_verbose_message "Select a keychain" fix
          funct_verbose_message "Select Edit" fix
          funct_verbose_message "Select Change Settings for keychain <keychain_name>" fix
          funct_verbose_message "Authenticate, if requested." fix
          funct_verbose_message "Change the Lock after # minutes of inactivity setting for the Login Keychain to 15" fix
          funct_verbose_message "" fix
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          secure=`expr $secure + 1`
          echo "Secure:    Keychain Lock time is set [$secure Passes]"
        fi
      fi
    else
      funct_verbose_message "" fix
      funct_verbose_message "Select Keychain Access" fix
      funct_verbose_message "Select a keychain" fix
      funct_verbose_message "Select Edit" fix
      funct_verbose_message "Select Change Settings for keychain <keychain_name>" fix
      funct_verbose_message "Authenticate, if requested." fix
      funct_verbose_message "Change the Lock after # minutes of inactivity setting for the Login Keychain to 15" fix
      funct_verbose_message "" fix
    fi
  fi
}
