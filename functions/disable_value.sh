# disable_value
#
# Code to comment out a line
#
# This routine takes 3 values
# check_file      = Name of file to check
# parameter_name  = Line to comment out
# comment_value   = The character to use as a comment, eg # (passed as hash)
#.

disable_value () {
  check_file=$1
  parameter_name=$2
  comment_value=$3
  if [ -f "$check_file" ]; then
    if [ "$comment_value" = "star" ]; then
      comment_value="*"
    else
      if [ "$comment_value" = "bang" ]; then
        comment_value="!"
      else
        comment_value="#"
      fi
    fi
    if [ "$audit_mode" = 2 ]; then
      restore_file $check_file $restore_dir
    else
      verbose_message "Parameter \"$parameter_name\" in $check_file is disabled"
      if [ "$separator" = "tab" ]; then
        param_hyphen=$( echo "$parameter_name" |grep "^[\-]" )
        if [ "$param_hyphen" ]; then
          parameter_name="\\$parameter_name"
        fi
        check_value=$( grep -v "^$comment_value" $check_file | grep "$parameter_name" | uniq )
        param_hyphen=$( echo "$parameter_name" |grep "^[\\]" )
        if [ "$param_hyphen" ]; then
          parameter_name=$( echo "$parameter_name" |sed "s/^[\\]//g" )
        fi
        if [ "$check_value" != "$parameter_name" ]; then
          increment_insecure "Parameter \"$parameter_name\" not set to \"$correct_value\" in $check_file"
          if [ "$audit_mode" = 0 ]; then
            verbose_message "Setting:   Parameter \"$parameter_name\" to \"$correct_value\" in $check_file"
            if [ "$check_file" = "/etc/system" ]; then
              reboot=1
              verbose_message "Notice:    Reboot required"
            fi
            if [ "$check_file" = "/etc/ssh/sshd_config" ] || [ "$check_file" = "/etc/sshd_config" ]; then
              verbose_message "Notice:    Service restart required SSH"
            fi
            backup_file $check_file
            cat $check_file | sed 's/$parameter_name/$comment_value&' > $temp_file
            cat $temp_file > $check_file
            if [ "$os_name" = "SunOS" ]; then
              if [ "$os_version" != "11" ]; then
                pkgchk -f -n -p $check_file 2> /dev/null
              else
                pkg fix $( pkg search $check_file | grep pkg | awk '{print $4}' )
              fi
            fi
            rm $temp_file
          fi
        fi
      else
        increment_secure "Parameter \"$parameter_name\" already set to \"$correct_value\" in $check_file"
      fi
    fi
  fi
}
