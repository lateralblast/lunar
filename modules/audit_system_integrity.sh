#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_system_integrity
#
# Check System Integrity Protection is enabled
#
# Refer to Section(s) 5.18    Page(s) 148-9     CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 5.1.2,4 Page(s) 300-3,5-6 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_system_integrity () {
  if [ "${os_name}" = "Darwin" ]; then
    verbose_message "System Integrity" "check"
    if [ "${audit_mode}" != 2 ]; then
      check=$( /usr/bin/csrutil status |grep enabled )
      if [ ! "${check}" ]; then
        increment_insecure "System Integrity Protection is not enabled"
      else
        increment_secure   "System Integrity Protection is enabled"
      fi
      if [ "${os_version}" -ge 11 ]; then
        verbose_message "Sealed System Volume" "check"
        check=$( /usr/bin/csrutil authenticated-root status |grep enabled )
        if [ -z "${check}" ]; then
          increment_insecure "Sealed System Volume is not enabled"
        else
          increment_secure   "Sealed System Volume is enabled"
        fi
      fi
    fi
  fi
}
