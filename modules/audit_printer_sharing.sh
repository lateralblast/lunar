# audit_printer_sharing
#
# Refer to Section 2.2.4 Page(s) 19-20 CIS Apple OS X 10.8 Benchmark v1.0.0
#
# Printer sharing can be disabled via: cupsctl --no-share-printers
# Need to update this code
#
#.

audit_printer_sharing() {
    if [ "$os_name" = "Darwin" ]; then
    verbose_message "Printer Sharing"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Printer Sharing is disabled"
      printer_test=`system_profiler SPPrintersDataType |grep Shared |awk '{print $2}' |grep 'Yes'`
      if [ "$printer_test" = "Yes" ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          insecure=`expr $insecure + 1`
          echo "Warning:   Printer sharing is enabled [$insecure Warnings]"
        fi
        if [ "$audit_mode" = 1 ] || [ "$audit_mode" = 0 ]; then
          verbose_message "" fix
          verbose_message "Open System Preferences" fix
          verbose_message "Select Sharing" fix
          verbose_message "Uncheck Printer Sharing" fix
          verbose_message "" fix
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          secure=`expr $secure + 1`
          echo "Secure:    Printer Sharing disabled [$secure Passes]"
        fi
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
