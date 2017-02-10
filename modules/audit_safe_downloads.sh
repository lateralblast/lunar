# audit_safe_downloads
#
# Refer to Section 2.6.3 Page(s) 29-30 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_safe_downloads() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Safe Downloads list"
    log_file="gatekeeper.log"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Safe Downloads list has been updated recently"
      update_file="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/XProtect.plist"
      actual_value=`find $update_file -mtime -30`
      if [ "$actual_value" != "$update_file" ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          insecure=`expr $insecure + 1`
          echo "Warning:   Safe Downloads list has not be updated recently [$insecure Warnings]"
          verbose_message "" fix
          verbose_message "Open System Preferences" fix
          verbose_message "Select Security & Privacy" fix
          verbose_message "Select the General tab" fix
          verbose_message "Select Advanced" fix
          verbose_message "Check Automatically update safe downloads list" fix
          verbose_message "" fix
          verbose_message "sudo /usr/libexec/XProtectUpdater" fix
          verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          echo "Updating:  Safe Downloads list [$insecure Warnings]"
          sudo /usr/libexec/XProtectUpdater
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          secure=`expr $secure + 1`
          echo "Secure:    Safe Downloads list has been updated recently [$secure Passes]"
        fi
      fi
    fi
  fi
}
