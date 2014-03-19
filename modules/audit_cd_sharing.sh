# audit_cd_sharing
#
# DVD or CD Sharing allows users to remotely access the system's optical drive.
# Disabling DVD or CD Sharing minimizes the risk of an attacker using the
# optical drive as a vector for attack.
#
# Refer to Section 2.4.6 Page(s) 22 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_cd_sharing() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "DVD/CD Sharing"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  DVD/CD Sharing is disabled"
      share_test=`launchctl list |awk '{print $3}' |grep ODSAgent |wc -l`
      if [ "$actual_value" = "1" ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score - 1`
          echo "Warning:   DVD/CD sharing is enabled [$score]"
        fi
        if [ "$audit_mode" = 1 ] || [ "$audit_mode" = 0 ]; then
          funct_verbose_message "" fix
          funct_verbose_message "Open System Preferences" fix
          funct_verbose_message "Select Sharing" fix
          funct_verbose_message "Uncheck DVD or CD Sharing" fix
          funct_verbose_message "" fix
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score + 1`
          echo "Secure:    DVD/CD Sharing disabled [$score]"
        fi
      fi
    else
      funct_verbose_message "" fix
      funct_verbose_message "Open System Preferences" fix
      funct_verbose_message "Select Sharing" fix
      funct_verbose_message "Uncheck DVD or CD Sharing" fix
      funct_verbose_message "" fix
    fi
  fi
}
