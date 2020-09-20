# audit_printer_sharing
#
# Refer to Section 2.2.4 Page(s) 19-20 CIS Apple OS X 10.8  Benchmark v1.0.0
# Refer to Section 2.2.4 Page(s) 41    CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to http://support.apple.com/kb/PH11450
#
# Printer sharing can be disabled via: cupsctl --no-share-printers
# Need to update this code
#
#.

audit_printer_sharing() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Printer Sharing"
    if [ "$audit_mode" != 2 ]; then
      printer_test=$( system_profiler SPPrintersDataType | grep Shared | awk '{print $2}' | grep 'Yes' )
      if [ "$printer_test" = "Yes" ]; then
        increment_insecure "Printer sharing is enabled"
        verbose_message "" fix
        verbose_message "Open System Preferences" fix
        verbose_message "Select Sharing" fix
        verbose_message "Uncheck Printer Sharing" fix
        verbose_message "" fix
      else
        increment_secure "Printer Sharing is disabled"
      fi
    else
      verbose_message "" fix
      verbose_message "Open System Preferences" fix
      verbose_message "Select Sharing" fix
      verbose_message "Uncheck Printer Sharing" fix
      verbose_message "" fix
    fi
  fi
}
