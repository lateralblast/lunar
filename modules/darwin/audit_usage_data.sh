#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_usage_data
#
# Apple provides a mechanism to send diagnostic and analytics data back to Apple to
# help them improve the platform. Information sent to Apple may contain internal
# organizational information that should be controlled and not available for processing by
# Apple. Turn off all Analytics and Improvements sharing.
#
# Refer to Section(s) 2.6.3 Page(s) 164-9 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_usage_data () {
  print_function "audit_usage_data"
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      verbose_message         "Usage Data" "check"
      check_osx_defaults_bool "Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist"  "AutoSubmit"           "0"
      check_osx_defaults_bool "Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist"  "ThirdPartyDataSubmit" "0"
      check_file_perms        "/Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist" "644"                  "root" "admin"
      verbose_message         "Siri Data Sharing" "check"
      if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
        verbose_message "Requires sudo to check" "notice"
        return
      fi
      if [ "${audit_mode}" != 2 ]; then
        user_list=$( find /Users -maxdepth 1 | grep -vE "localized|Shared" | cut -f3 -d/ )
        for user_name in ${user_list}; do
          check_osx_defaults_user "com.apple.assistant.support" "Siri Data Sharing Opt-In Status" "2" "int" "${user_name}"
        done
      fi
    fi
  fi
}
