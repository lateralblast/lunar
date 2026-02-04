#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_lockdown
#
# When lockdown mode is enabled, specific trusted websites can be excluded from
# Lockdown protection if necessary.
#
# Refer to Section(s) 2.6.7 Page(s) 181-2 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_lockdown () {
  print_function "audit_lockdown"
  string="Lockdown Mode"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
        verbose_message "Requires sudo to check" "notice"
        return
      fi
      if [ "${audit_mode}" != 2 ]; then
        command="find /Users -maxdepth 1 | grep -vE \"localized|Shared\" | cut -f3 -d/"
        command_message "${command}"
        user_list=$( eval "${command}" )
        for user_name in ${user_list}; do
          check_osx_defaults_bool ".GlobalPreferences" "LDMGlobalEnabled" "1"
        done
      fi
    fi
  else
    na_message "${string}"
  fi
}
