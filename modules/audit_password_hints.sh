#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_password_hints
#
# Password hints make it easier for unauthorized persons to gain access to systems by
# displaying information provided by the user to assist in remembering the password. This
# info could include the password itself or other information that might be readily
# discerned with basic knowledge of the end user.
#
# Refer to Section 6.1.2  Page(s) 73-4  CIS Apple OS X 10.8  Benchmark v1.0.0
# Refer to Section 6.1.2  Page(s) 154-5 CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section 2.10.5 Page(s) 231-3 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_login_details () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message        "Login display details" "check"
    check_osx_defaults_int "/Library/Preferences/com.apple.loginwindow" "RetriesUntilHint" "0"
  fi
}
