# funct_launchctl_check
#
# Function to check launchctl output under OS X
#.

funct_launchctl_check () {
  if [ "$os_name" = "Darwin" ]; then
    launchctl_service=$1
    total=`expr $total + 1`
    if [ "$audit_mode" != 2 ]; then
      check_vale=`launchctl list |grep $launchctl_service |awk '{print $3}'`
      if [ "$check_value" = "$launchctl_service" ]; then
        score=`expr $score - 1`
        echo "Warning:   Service $launchctl_service enabled [$score]"
        funct_verbose_message "" fix
        funct_verbose_message "sudo launchctl unload -w $launchctl_service.plist" fix
        funct_verbose_message "" fix
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $dscl_dir$dscl_file
          echo "Setting:   Service $launchctl_service to disabled"
          sudo launchctl unload -w $launchctl_service.plist
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score + 1`
          echo "Secure:    Service $launchctl_service to disabled [$score]"
        fi
      fi
    else
      sudo launchctl load -w $launchctl_service.plist
    fi
  fi
}
