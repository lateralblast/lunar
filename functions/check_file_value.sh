# check_file_value
#
# Audit file values
#
# This routine takes four values
#
# check_file      = The name of the file to check
# parameter_name  = The parameter to be checked
# seperator       = Character used to seperate parameter name from it's value (eg =)
# correct_value   = The value we expect to be returned
# comment_value   = Character used as a comment (can be #, *, etc)
#
# If the current_value is not the correct_value then it is fixed if run in lockdown mode
# A copy of the value is stored in a log file, which can be restored
#.

check_file_value () {
  check_file=$1
  parameter_name=$2
  separator=$3
  correct_value=$4
  comment_value=$5
  position=$6
  search_value=$7
  if [ "$comment_value" = "star" ]; then
    comment_value="*"
  else
    if [ "$comment_value" = "bang" ]; then
      comment_value="!"
    else
      if [ "$comment_value" = "semicolon" ]; then
        comment_value=";"
      else
        comment_value="#"
      fi
    fi
  fi
  if [ `expr "$separator" : "eq"` = 2 ]; then
    separator="="
    spacer="\="
  else
    if [ `expr "$separator" : "space"` = 5 ]; then
      separator=" "
      spacer=" "
    else
      if [ `expr "$separator" : "colon"` = 5 ]; then
        separator=":"
        space=":"
      fi
    fi
  fi
  if [ "$id_check" = "0" ] || [ "$os_name" = "VMkernel" ]; then
    cat_command="cat"
    sed_command="sed"
    echo_command="echo"
  else
    cat_command="sudo cat"
    sed_command="sudo sed"
    echo_command="sudo echo"
  fi
  if [ "$audit_mode" = 2 ]; then
    restore_file $check_file $restore_dir
  else
    echo "Checking:  Value of \"$parameter_name\" is set to \"$correct_value\" in $check_file"
    if [ ! -f "$check_file" ]; then
      if [ "$audit_mode" = 1 ]; then
        increment_insecure "Parameter \"$parameter_name\" not set to \"$correct_value\" in $check_file"
        if [ "$check_file" = "/etc/default/sendmail" ] || [ "$check_file" = "/etc/sysconfig/mail" ]; then
          verbose_message "" fix
          verbose_message "echo \"$parameter_name$separator\"$correct_value\" >> $check_file" fix
          verbose_message "" fix
        else
          verbose_message "" fix
          verbose_message "echo \"$parameter_name$separator$correct_value\" >> $check_file" fix
          verbose_message "" fix
        fi
      else
        if [ "$audit_mode" = 0 ]; then
          echo "Setting:   Parameter \"$parameter_name\" to \"$correct_value\" in $check_file"
          if [ "$check_file" = "/etc/system" ]; then
            reboot=1
            echo "Notice:    Reboot required"
          fi
          if [ "$check_file" = "/etc/ssh/sshd_config" ] || [ "$check_file" = "/etc/sshd_config" ]; then
            echo "Notice:    Service restart required for SSH"
          fi
          backup_file $check_file
          if [ "$check_file" = "/etc/default/sendmail" ] || [ "$check_file" = "/etc/sysconfig/mail" ] || [ "$check_file" = "/etc/rc.conf" ] || [ "$check_file" = "/boot/loader.conf" ] || [ "$check_file" = "/etc/sysconfig/boot" ]; then
            echo "$parameter_name$separator\"$correct_value\"" >> $check_file
          else
            echo "$parameter_name$separator$correct_value" >> $check_file
          fi
        fi
      fi
    else
      if [ "$separator" = "tab" ]; then
        check_value=`$cat_command $check_file |grep -v "^$comment_value" |grep "$parameter_name" |awk '{print $2}' |sed 's/"//g' |uniq`
      else
        check_value=`$cat_command $check_file |grep -v "^$comment_value" |grep "$parameter_name" |cut -f2 -d"$separator" |sed 's/"//g' |sed 's/ //g' |uniq`
      fi
      if [ "$check_value" != "$correct_value" ]; then
        if [ "$audit_mode" = 1 ]; then
          increment_insecure "Parameter \"$parameter_name\" not set to \"$correct_value\" in $check_file"
          if [ "$check_parameter" != "$parameter_name" ]; then
            if [ "$separator_value" = "tab" ]; then
              verbose_message "" fix
              verbose_message "echo -e \"$parameter_name\t$correct_value\" >> $check_file" fix
              verbose_message "" fix
            else
              if [ "$position" = "after" ]; then
                verbose_message "" fix
                verbose_message "$cat_command $check_file |sed \"s,$search_value,&\n$parameter_name$separator$correct_value,\" > $temp_file" fix
                verbose_message "$cat_command $temp_file > $check_file" fix
                verbose_message "" fix
              else
                verbose_message "" fix
                verbose_message "echo \"$parameter_name$separator$correct_value\" >> $check_file" fix
                verbose_message "" fix
              fi
            fi
          else
            if [ "$check_file" = "/etc/default/sendmail" ] || [ "$check_file" = "/etc/sysconfig/mail" ] || [ "$check_file" = "/etc/rc.conf" ] || [ "$check_file" = "/boot/loader.conf" ] || [ "$check_file" = "/etc/sysconfig/boot" ]; then
              verbose_message "" fix
              verbose_message "$sed_command \"s/^$parameter_name.*/$parameter_name$spacer\"$correct_value\"/\" $check_file > $temp_file" fix
            else
              verbose_message "" fix
              verbose_message "$sed_command \"s/^$parameter_name.*/$parameter_name$spacer$correct_value/\" $check_file > $temp_file" fix
            fi
            verbose_message "$cat_command $temp_file > $check_file" fix
            verbose_message "" fix
          fi
        else
          if [ "$audit_mode" = 0 ]; then
            if [ "$separator" = "tab" ]; then
              check_parameter=`$cat_command $check_file |grep -v "^$comment_value" |grep "$parameter_name" |awk '{print $1}'`
            else
              check_parameter=`$cat_command $check_file |grep -v "^$comment_value" |grep "$parameter_name" |cut -f1 -d"$separator" |sed 's/ //g' |uniq`
            fi
            echo "Setting:   Parameter \"$parameter_name\" to \"$correct_value\" in $check_file"
            if [ "$check_file" = "/etc/system" ]; then
              reboot=1
              echo "Notice:    Reboot required"
            fi
            if [ "$check_file" = "/etc/ssh/sshd_config" ] || [ "$check_file" = "/etc/sshd_config" ]; then
              echo "Notice:    Service restart required for SSH"
            fi
            backup_file $check_file
            if [ "$check_parameter" != "$parameter_name" ]; then
              if [ "$separator_value" = "tab" ]; then
                $echo_command -e "$parameter_name\t$correct_value" >> $check_file
              else
                if [ "$position" = "after" ]; then
                  $cat_command $check_file |sed "s,$search_value,&\n$parameter_name$separator$correct_value," > $temp_file
                  $cat_command $temp_file > $check_file
                else
                  $echo_command "$parameter_name$separator$correct_value" >> $check_file
                fi
              fi
            else
              if [ "$check_file" = "/etc/default/sendmail" ] || [ "$check_file" = "/etc/sysconfig/mail" ] || [ "$check_file" = "/etc/rc.conf" ] || [ "$check_file" = "/boot/loader.conf" ] || [ "$check_file" = "/etc/sysconfig/boot" ]; then
                $sed_command "s/^$parameter_name.*/$parameter_name$spacer\"$correct_value\"/" $check_file > $temp_file
              else
                $sed_command "s/^$parameter_name.*/$parameter_name$spacer$correct_value/" $check_file > $temp_file
              fi
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
        fi
      else
        increment_secure "Parameter \"$parameter_name\" already set to \"$correct_value\" in $check_file"
      fi
    fi
  fi
}
