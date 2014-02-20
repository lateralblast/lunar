# funct_disable_value
#
# Code to comment out a line
#
# This routine takes 3 values
# check_file      = Name of file to check
# parameter_name  = Line to comment out
# comment_value   = The character to use as a comment, eg # (passed as hash)
#.

funct_disable_value () {
  check_file=$1
  parameter_name=$2
  comment_value=$3
  total=`expr $total + 1`
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
      funct_restore_file $check_file $restore_dir
    else
      echo "Checking:  Parameter \"$parameter_name\" in $check_file is disabled"
    fi
    if [ "$separator" = "tab" ]; then
      check_value=`cat $check_file |grep -v "^$comment_value" |grep "$parameter_name" |uniq`
      if [ "$check_value" != "$parameter_name" ]; then
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score - 1`
          echo "Warning:   Parameter \"$parameter_name\" not set to \"$correct_value\" in $check_file [$score]"
          funct_verbose_message "" fix
          funct_verbose_message "cat $check_file |sed 's/$parameter_name/$comment_value&' > $temp_file" fix
          funct_verbose_message "cat $temp_file > $check_file" fix
          funct_verbose_message "" fix
        else
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   Parameter \"$parameter_name\" to \"$correct_value\" in $check_file"
            if [ "$check_file" = "/etc/system" ]; then
              reboot=1
              echo "Notice:    Reboot required"
            fi
            if [ "$check_file" = "/etc/ssh/sshd_config" ] || [ "$check_file" = "/etc/sshd_config" ]; then
              echo "Notice:    Service restart required SSH"
            fi
            funct_backup_file $check_file
            cat $check_file |sed 's/$parameter_name/$comment_value&' > $temp_file
            cat $temp_file > $check_file
            if [ "$os_name" = "SunOS" ]; then
              if [ "$os_version" != "11" ]; then
                pkgchk -f -n -p $check_file 2> /dev/null
              else
                pkg fix `pkg search $check_file |grep pkg |awk '{print $4}'`
              fi
            fi
            rm $temp_file
          fi
        fi
      else
        if [ "$audit_mode" != 2 ]; then
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score + 1`
            echo "Secure:    Parameter \"$parameter_name\" already set to \"$correct_value\" in $check_file [$score]"
          fi
        fi
      fi
    fi
  fi
}
