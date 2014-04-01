# audit_shadow_group
#
# The shadow group allows system programs which require access the ability to
# read the /etc/shadow file. No users should be assigned to the shadow group.
# Any users assigned to the shadow group would be granted read access to the
# /etc/shadow file. If attackers can gain read access to the /etc/shadow file,
# they can easily run a password cracking program against the hashed passwords
# to break them. Other security information that is stored in the /etc/shadow
# file (such as expiration) could also be useful to subvert additional user
# accounts.
#
# Refer to Section(s) 13.20 Page(s) 168-9 SLES 11 Benchmark v1.0.0
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
          score=`expr $score - 1`
          echo "Warning:   Shadow group contains members [$score]"
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
          score=`expr $score + 1`
          echo "Secure:    No members in shadow group [$score]"
        fi
      fi
    fi
  fi
}
