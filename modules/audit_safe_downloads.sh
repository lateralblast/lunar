# audit_safe_downloads
#
# Apple maintains a list of known malicious software that is used during the
# safe download check to determine if a file contains malicious software,
# the list is updated daily by a background process.
#
# Refer to Section 2.6.3 Page(s) 29-30 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_safe_downloads() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Safe Downloads list"
    log_file="gatekeeper.log"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Safe Downloads list has been updated recently"
      update_file="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/XProtect.plist"
      actual_value=`find $update_file -mtime -30`
      if [ "$actual_value" != "$update_file" ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score - 1`
          echo "Warning:   Safe Downloads list has not be updated recently [$score]"
          funct_verbose_message "" fix
          funct_verbose_message "Open System Preferences" fix
          funct_verbose_message "Select Security & Privacy" fix
          funct_verbose_message "Select the General tab" fix
          funct_verbose_message "Select Advanced" fix
          funct_verbose_message "Check Automatically update safe downloads list" fix
          funct_verbose_message "" fix
          funct_verbose_message "sudo /usr/libexec/XProtectUpdater" fix
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          echo "Updating:  Safe Downloads list [$score]"
          sudo /usr/libexec/XProtectUpdater
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score + 1`
          echo "Secure:    Safe Downloads list has been updated recently [$score]"
        fi
      fi
    fi
  fi
}
