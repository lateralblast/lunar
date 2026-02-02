#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_printer_sharing
#
# Refer to Section(s) 2.2.4   Page(s) 19-20 CIS Apple OS X 10.8  Benchmark v1.0.0
# Refer to Section(s) 2.2.4   Page(s) 41    CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 2.3.3.4 Page(s) 98-9  CIS Apple macOS 14 Sonoma Benchmark v1.0.0
# Refer to http://support.apple.com/kb/PH11450
#
# Printer sharing can be disabled via: cupsctl --no-share-printers
# Need to update this code
#.

audit_printer_sharing () {
  print_function "audit_printer_sharing"
  string="Printer Sharing"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${audit_mode}" != 2 ]; then
      if [ "${long_os_version}" -ge 1014 ]; then
        command="/usr/bin/sudo /usr/sbin/cupsctl | grep -c \"_share_printers=0\""
        command_message "${command}"
        printer_test=$( eval "${command}" )
      else
        command="system_profiler SPPrintersDataType | grep Shared | awk '{print \$2}' | grep -c 'Yes' | sed \"s/ //g\""
        command_message "${command}"
        printer_test=$( eval "${command}" )
      fi
      if [ "${printer_test}" = "0" ]; then
        increment_insecure  "Printer sharing is enabled"
        verbose_message     "Open System Preferences"   "fix"
        verbose_message     "Select Sharing"            "fix"
        verbose_message     "Uncheck Printer Sharing"   "fix"
      else
        increment_secure    "Printer Sharing is disabled"
      fi
    else
      verbose_message       "Open System Preferences"   "fix"
      verbose_message       "Select Sharing"            "fix"
      verbose_message       "Uncheck Printer Sharing"   "fix"
    fi
  else
    na_message "${string}"
  fi
}
