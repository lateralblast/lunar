# check_append_file
#
# Code to append a file with a line
#
# check_file      = The name of the original file
# parameter       = The parameter/line to add to a file
# comment_value   = The character used in the file to distinguish a line as a comment
#.

check_append_file () {
  check_file=$1
  parameter=$2
  comment_value=$3
  total=`expr $total + 1`
  if [ "$comment_value" = "star" ]; then
    comment_value="*"
  else
    comment_value="#"
  fi
  if [ "$audit_mode" = 2 ]; then
    restore_file="$restore_dir$check_file"
    if [ -f "$restore_file" ]; then
      diff_check=`diff $check_file $restore_file |wc -l`
      if [ "$diff_check" != 0 ]; then
        restore_file $check_file $restore_dir
        if [ "$check_file" = "/etc/system" ]; then
          reboot=1
          echo "Notice:    Reboot required"
        fi
        if [ "$check_file" = "/etc/ssh/sshd_config" ] || [ "$check_file"i = "/etc/sshd_config" ]; then
          echo "Notice:    Service restart required for SSH"
        fi
      fi
    fi
  else
    echo "Checking:  Parameter \"$parameter\" is set in $check_file"
  fi
  if [ ! -f "$check_file" ]; then
    if [ "$audit_mode" = 1 ]; then
      insecure=`expr $insecure + 1`
      echo "Warning:   Parameter \"$parameter\" does not exist in $check_file [$insecure Warnings]"
      funct_verbose_message "" fix
      funct_verbose_message "echo \"$parameter\" >> $check_file" fix
      funct_verbose_message "" fix
    else
      if [ "$audit_mode" = 0 ]; then
        echo "Setting:   Parameter \"$parameter_name\" in $check_file"
        if [ "$check_file" = "/etc/system" ]; then
          reboot=1
          echo "Notice:    Reboot required"
        fi
        if [ "$check_file" = "/etc/ssh/sshd_config" ] || [ "$check_file" = "/etc/sshd_config" ]; then
          echo "Notice:    Service restart required for SSH"
        fi
        if [ ! -f "$work_dir$check_file" ]; then
          touch $check_file
          backup_file $check_file
        fi
        echo "$parameter" >> $check_file
      fi
    fi
  else
    check_value=`cat $check_file |grep -v '^$comment_value' |grep '$parameter'`
    if [ "$check_value" != "$parameter" ]; then
      if [ "$audit_mode" = 1 ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   Parameter \"$parameter\" does not exist in $check_file [$insecure Warnings]"
        funct_verbose_message "" fix
        funct_verbose_message "echo \"$parameter\" >> $check_file" fix
        funct_verbose_message "" fix
      else
        if [ "$audit_mode" = 0 ]; then
          echo "Setting:   Parameter \"$parameter\" in $check_file"
          if [ "$check_file" = "/etc/system" ]; then
            reboot=1
            echo "Notice:    Reboot required"
          fi
          if [ "$check_file" = "/etc/ssh/sshd_config" ] || [ "$check_file" = "/etc/sshd_config" ]; then
            echo "Notice:    Service restart required for SSH"
          fi
          backup_file $check_file
          echo "$parameter" >> $check_file
        fi
      fi
    else
      if [ "$audit_mode" != 2 ]; then
        if [ "$audit_mode" = 1 ]; then
          secure=`expr $secure + 1`
          echo "Secure:    Parameter \"$parameter\" exists in $check_file [$secure Passes]"
        fi
      fi
    fi
  fi
}
