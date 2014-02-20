# audit_root_primary_group
#
# Make sure root's primary group is root
#.

audit_root_primary_group () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Root Primary Group"
    log_file="root_primary_grooup.log"
    check_file="/etc/group"
    group_check=`grep "^root:" /etc/passwd | cut -f4 -d:`
    total=`expr $total + 1`
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Primary group for root is root"
      if [ "$group_check" != "0" ];then
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score - 1`
          echo "Warning:   Group $group_id does not exist in group file [$score]"
          funct_verbose_message "" fix
          funct_verbose_message "usermod -g 0 root" fix
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ];then
          log_file="$work_dir/$log_file"
          echo "$group_check" > $log_file
          echo "Setting:   Primary group for root to root"
          usermod -g 0 root
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score + 1`
          echo "Secure:    Primary group for root is root [$score]"
        fi
      fi
    else
      restore_file="$restore_dir/$log_file"
      if [ -e "$restore_file" ]; then
        restore_value=`cat $restore_file`
        if [ "$restore_value" != "$group_check" ]; then
          usermod -g $restore_value root
        fi
      fi
    fi
  fi
}
