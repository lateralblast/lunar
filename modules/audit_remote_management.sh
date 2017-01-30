# audit_remote_management
#
# Refer to Section 2.2.9 Page(s) 25-26 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_remote_management() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Remote Management"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Remote Management is disabled"
      actual_value=`launchctl list |awk '{print $3}' |grep ARDAgent |wc -l`
      if [ "$actual_value" = "1" ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          insecure=`expr $insecure + 1`
          echo "Warning:   Remote Management is enabled [$insecure Warnings]"
        fi
        if [ "$audit_mode" = 1 ] || [ "$audit_mode" = 0 ]; then
          funct_verbose_message "" fix
          funct_verbose_message "Open System Preferences" fix
          funct_verbose_message "Select Sharing" fix
          funct_verbose_message "Uncheck Remote Management" fix
          funct_verbose_message "" fix
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          secure=`expr $secure + 1`
          echo "Secure:    Remote Management is disabled [$secure Passes]"
        fi
      fi
    else
      funct_verbose_message "" fix
      funct_verbose_message "Open System Preferences" fix
      funct_verbose_message "Select Sharing" fix
      funct_verbose_message "Uncheck Remote Management" fix
      funct_verbose_message "" fix
    fi
  fi
}
