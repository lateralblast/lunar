#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_safari_auto_fill
#
# Check Safari Auto Fill
#
# Refer to Section(s) 6.3.8 Page(s) 403-5 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_safari_auto_fill () {
  print_module "audit_safari_auto_fill"
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      verbose_message "Safari Auto Fill" "check"
      if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
        verbose_message "Requires sudo to check" "notice"
        return
      fi
      if [ "${audit_mode}" != 2 ]; then
        user_list=$( find /Users -maxdepth 1 | grep -vE "localized|Shared" | cut -f3 -d/ )
        for user_name in ${user_list}; do
          for parameter in AutoFillFromAddressBook AutoFillPasswords AutoFillCreditCardData AutoFillMiscellaneousForms; do
            check_osx_defaults_user "com.apple.Safari" "${parameter}" "0" "bool" "${user_name}"
          done
        done
      fi
    fi
  fi
}
