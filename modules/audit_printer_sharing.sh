# audit_printer_sharing
#
# Disabling Printer Sharing mitigates the risk of attackers attempting to
# exploit the print server to gain access to the system.
#
# Refer to Section 2.2.4 Page(s) 19-20 CIS Apple OS X 10.8 Benchmark v1.0.0
#
# Printer sharing can be disabled via: cupsctl --no-share-printers
# Need to update this code
#
#.

audit_printer_sharing() {
    if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Printer Sharing"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Printer Sharing is disabled"
      printer_test=`system_profiler SPPrintersDataType |grep Shared |awk '{print $2}' |grep 'Yes'`
      if [ "$printer_test" = "Yes" ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score - 1`
          echo "Warning:   Printer sharing is enabled [$score]"
        fi
        if [ "$audit_mode" = 1 ] || [ "$audit_mode" = 0 ]; then
          funct_verbose_message "" fix
          funct_verbose_message "Open System Preferences" fix
          funct_verbose_message "Select Sharing" fix
          funct_verbose_message "Uncheck Printer Sharing" fix
          funct_verbose_message "" fix
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score + 1`
          echo "Secure:    Printer Sharing disabled [$score]"
        fi
      fi
    else
      funct_verbose_message "" fix
      funct_verbose_message "Open System Preferences" fix
      funct_verbose_message "Select Sharing" fix
      funct_verbose_message "Uncheck Printer Sharing" fix
      funct_verbose_message "" fix
    fi
  fi
}
