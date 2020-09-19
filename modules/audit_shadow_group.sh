# audit_shadow_group
#
# Refer to Section(s) 13.20  Page(s) 168-9 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.2.20 Page(s) 287 SLES 11 Benchmark v1.0.0
#.

audit_shadow_group () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Shadow Group"
    check_file="/etc/group"
    temp_file="$temp_dir/group"
    if [ "$audit_mode" = 2 ]; then
      restore_file $check_file $restore_dir
    fi
    if [ "$audit_mode" != 2 ]; then
      shadow_check=$( grep -v "^#" $check_file | grep ^shadow | cut -f4 -d":" | wc -c )
      if [ "$shadow_check" != 0 ]; then
        if [ "$audit_mode" = 1 ]; then
          increment_insecure "Shadow group contains members"
          verbose_message "" fix
          verbose_message "cat $check_file |awk -F':' '( $1 == \"shadow\" ) {print $1\":\"$2\":\"$3\":\" ; next}; {print}' > $temp_file" fix
          verbose_message "cat $temp_file > $check_file" fix
          verbose_message "rm $temp_file" fix
          verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          backup_file $check_file
          cat $check_file |awk -F':' '( $1 == "shadow" ) {print $1":"$2":"$3":" ; next}; {print}' > $temp_file
          cat $temp_file > $check_file
          rm $temp_file
        fi
      else
        if [ "$audit_mode" = 1 ];then
          increment_secure "No members in shadow group"
        fi
      fi
    fi
  fi
}
