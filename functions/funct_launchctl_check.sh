# funct_launchctl_check
#
# Function to check launchctl output under OS X
#.

funct_launchctl_check () {
  if [ "$os_name" = "Darwin" ]; then
    launchctl_service=$1
    required_status=$2
    log_file="$launchctl_service.log"
    if [ "$required_status" = "on" ] || [ "$required_status" = "enable" ]; then
      required_status="enabled"
      change_status="load"
    else
      required_status="disabled"
      change_status="unload"
    fi
    total=`expr $total + 1`
    check_value=`launchctl list |grep $launchctl_service |awk '{print $3}'`
    if [ "$check_value" = "$launchctl_service" ]; then
      actual_status="enabled"
    else
      actual_status="disabled"
    fi
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Service $launchctl_service is $required_status"
      if [ "$actual_status" != "$required_status" ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   Service $launchctl_service is $actual_status [$insecure Warnings]"
        funct_verbose_message "" fix
        funct_verbose_message "sudo launchctl $change_status -w $launchctl_service.plist" fix
        funct_verbose_message "" fix
        if [ "$audit_mode" = 0 ]; then
          log_file="$work_dir/$log_file"
          echo "$actual_status" > $log_file
          echo "Setting:   Service $launchctl_service to $required_status"
          sudo launchctl $change_status -w $launchctl_service.plist
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          secure=`expr $secure + 1`
          echo "Secure:    Service $launchctl_service is $required_status [$secure Passes]"
        fi
      fi
    else
      log_file="$restore_dir/$log_file"
      if [ -f "$log_file" ]; then
        restore_status=`cat $log_file`
        if [ "$restore_status" = "enabled" ]; then
          change_status="load"
        else
          change_status="unload"
        fi
        if [ "$restore_status" != "$actual_status" ]; then
          sudo launchctl $change_status -w $launchctl_service.plist
        fi
      fi
    fi
  fi
}
