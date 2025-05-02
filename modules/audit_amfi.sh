#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_amfi
#
# Apple Mobile File Integrity validates that application code is validated.
#
# Refer to Section(s) 5.1.3 Page(s) 303-4 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_amfi () {
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1012 ]; then
      verbose_message "Apple Mobile File Integrity" "check"
      if [ "${audit_mode}" != 2 ]; then
        check_value=$( sudo nvram -p > /dev/null 2>&1 | grep -c amfi | sed "s/ //g" )
        if [ "${check_value}" = "0" ]; then
          increment_secure   "Apple Mobile File Integrity is not \"disabled\""
        else
          increment_insecure "Apple Mobile File Integrity is set to \"${check_value}\""
        fi
      fi
    fi
  fi
}
