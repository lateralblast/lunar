# audit_shadow_group
#
# Refer to Section(s) 13.20  Page(s) 168-9 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.2.20 Page(s) 287 SLES 11 Benchmark v1.0.0
#.

audit_shadow_group () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Shadow Group"
    check_file="/etc/group"
    temp_file="$temp_dir/group"
    if [ "$audit_mode" = 2 ]; then
      funct_restore_file $check_file $restore_dir
    else
      echo "Checking:  Shadow group does not contain users"
    fi
    total=`expr $total + 1`
    if [ "$audit_mode" != 2 ]; then
      shadow_check=`cat $check_file |grep -v "^#" |grep ^shadow |cut -f4 -d":" |wc -c`
      if [ "$shadow_check" != 0 ]; then
        if [ "$audit_mode" = 1 ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Shadow group contains members [$insecure Warnings]"
          funct_verbose_message "" fix
          funct_verbose_message "cat $check_file |awk -F':' '( $1 == \"shadow\" ) {print $1\":\"$2\":\"$3\":\" ; next}; {print}' > $temp_file" fix
          funct_verbose_message "cat $temp_file > $check_file" fix
          funct_verbose_message "rm $temp_file" fix
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $check_file
          cat $check_file |awk -F':' '( $1 == "shadow" ) {print $1":"$2":"$3":" ; next}; {print}' > $temp_file
          cat $temp_file > $check_file
          rm $temp_file
        fi
      else
        if [ "$audit_mode" = 1 ];then
          secure=`expr $secure + 1`
          echo "Secure:    No members in shadow group [$secure Passes]"
        fi
      fi
    fi
  fi
}
