#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_secure_empty_trash
#
# Check secure empty trash settings
#
# Refer to Section(s) 2.8 Page(s) 33 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_secure_empty_trash () {
  if [ "${os_name}" = "Darwin" ]; then
    verbose_message        "Secure Empty Trash" "check"
    check_osx_defaults_int "com.apple.finder" "EmptyTrashSecurely" "1"
  fi
}
