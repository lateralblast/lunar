#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_secure_keyboard_entry
#
# Check secure keyboard entry settings
#
# Refer to Section(s) 2.8   Page(s) 33    CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(S) 2.10  Page(s) 81    CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 6.4.1 Page(s) 413-6 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_secure_keyboard_entry () {
  print_module "audit_secure_keyboard_entry"
  if [ "${os_name}" = "Darwin" ]; then
    verbose_message        "Secure Keyboard Entry"  "check"
    check_osx_defaults_int "Terminal"               "SecureKeyboardEntry" "1" "int"
  fi
}
