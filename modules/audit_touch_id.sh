# audit_touch_id
#
# Touch ID allows for an account-enrolled fingerprint to access a key that uses a
# previously provided password.
#
# Refer to Section(s) 2.11.2 Page(s) 237-40 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_touch_id () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Touch ID"
      if [ "$audit_mode" != 2 ]; then
        check_value=$( sudo bioutil -r -s |egrep "Touch|Biometric" |grep timeout |cut -f2 -d: |sed "s/ //g" 2>&1 > /dev/null )
        if [ "$check_value" = "$touchid_timeout" ]; then
          increment_secure "Touch ID Timeout for system is set to $touchid_timeout"
        else
          increment_insecure "Touch ID Timeout for system is not set to $touchid_timeout"
        fi
        for user_name in `ls /Users |grep -v Shared`; do
          check_value=$( sudo -u $user_name bioutil -r |egrep "Touch|Biometric" |grep timeout |cut -f2 -d: |sed "s/ //g" 2>&1 > /dev/null )
          if [ "$check_value" = "$touchid_timeout" ]; then
            increment_secure "Touch ID Timeout for $user_name is set to $touchid_timeout"
          else
            increment_insecure "Touch ID Timeout for for $user_name is not set to $touchid_timeout"
          fi
        done
      fi
    fi
  fi
}
