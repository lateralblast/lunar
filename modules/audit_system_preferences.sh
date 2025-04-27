#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_system_preferences
#
# Chec whether a password is required to access system-wide preferences
#
# Refer to Section(s) 5.8 Page(s) 138-9 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_system_preferences () {
  if [ "${os_name}" = "Darwin" ]; then
    verbose_message "System Preferences" "check"
    if [ ! "${audit_mode}" != 2 ]; then
      check=$( security authorizationdb read system.preferences 2> /dev/null | grep -A1 shared | grep true )
      if [ "${check}" ]; then
        increment_insecure "An Administrator password is not required to access system-wide preferences"
      else
        increment_secure "An Administrator password is required to access system-wide preferences"
      fi
    fi
  fi
}
