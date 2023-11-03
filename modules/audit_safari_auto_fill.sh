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
          for parameter in AutoFillFromAddressBook AutoFillPasswords AutoFillCreditCardData AutoFillMiscellaneousForms; do
            check_osx_defaults com.apple.Safari $parameter 0 bool $user_name
          done
        done
      fi
    fi
  fi
}
