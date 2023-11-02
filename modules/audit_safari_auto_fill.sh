# audit_safari_auto_fill
#
# Check Safari Auto Fill
#
# Refer to Section(s) 6.3.8 Page(s) 403-5 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_safari_auto_fill () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Safari Auto Fill"
      if [ "$audit_mode" != 2 ]; then
        value="0"
        for user_name in `ls /Users |grep -v Shared`; do
          check_value=$( /usr/bin/sudo -u $user_name /usr/bin/defaults read /Users/$user_name/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari AutoFillFromAddressBook 2>&1 > /dev/null )
          if [ "$check_value" = "$value" ]; then
            increment_secure "Safari Auto Fill From Address Book for $user_name is set to $value"
          else
            increment_insecure "Safari Auto Fill From Address Book for $user_name is not set to $value"
          fi
          check_value=$( /usr/bin/sudo -u $user_name /usr/bin/defaults read /Users/$user_name/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari AutoFillPasswords 2>&1 > /dev/null )
          if [ "$check_value" = "$value" ]; then
            increment_secure "Safari Auto Fill Passwords for $user_name is set to $value"
          else
            increment_insecure "Safari Auto Fill Passwords for $user_name is not set to $value"
          fi
          check_value=$( /usr/bin/sudo -u $user_name /usr/bin/defaults read /Users/$user_name/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari AutoFillCreditCardData 2>&1 > /dev/null )
          if [ "$check_value" = "$value" ]; then
            increment_secure "Safari Auto Fill Credit Card Data for $user_name is set to $value"
          else
            increment_insecure "Safari Auto Fill Credit Card Data for $user_name is not set to $value"
          fi
          check_value=$( /usr/bin/sudo -u $user_name /usr/bin/defaults read /Users/$user_name/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari AutoFillMiscellaneousForms 2>&1 > /dev/null )
          if [ "$check_value" = "$value" ]; then
            increment_secure "Safari Auto Fill Miscellaneous Forms for $user_name is set to $value"
          else
            increment_insecure "Safari Auto Fill Miscellaneous Forms for $user_name is not set to $value"
          fi
        done
      fi
    fi
  fi
}
