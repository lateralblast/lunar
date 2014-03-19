# audit_software_update
#
# Ensure OS X is set to autoupdate
#
# Refer to Page(s) 8 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_software_update() {
  if [ "$os_name" = "Darwin" ]; then
    actual_status=`sudo softwareupdate --schedule |awk '{print $4}'`
    log_file="softwareupdate.log"
    correct_status="on"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  If Software Update is enabled"
      total=`expr $total + 1`
      if [ "$actual_status" != "$correct_status" ]; then
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score - 1`
          echo "Warning:   Software Update is not $correct_status [$score]"
          command_line="sudo softwareupdate --schedule $correct_status"
          funct_verbose_message "" fix
          funct_verbose_message "$command_line" fix
          funct_verbose_message "" fix
        else
          if [ "$audit_mode" = 0 ]; then
            log_file="$work_dir/$log_file"
            echo "$actual_status" > $log_file
            echo "Setting:   Software Update schedule to $correct_status"
            sudo softwareupdate --schedule $correct_status
          fi
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score + 1`
          echo "Secure:    Software Update is $correct_status [$score]"
        fi
      fi
    else
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        previous_status=`cat $restore_file`
        if [ "$previous_status" != "$actual_status" ]; then
          funct_verbose_message ""
          funct_verbose_message "Restoring:   Software Update to $previous_status"
          funct_verbose_message ""
          sudo suftwareupdate --schedule $previous_status
        fi
      fi
    fi
  fi
}
