# audit_groups_exist
#
# Over time, system administration errors and changes can lead to groups being
# defined in /etc/passwd but not in /etc/group.
# Groups defined in the /etc/passwd file but not in the /etc/group file pose a
# threat to system security since group permissions are not properly managed.
#.

audit_groups_exist () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "User Groups"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Groups in passwd file exist in group file"
    fi
    check_file="/etc/group"
    group_fail=0
    total=`expr $total + 1`
    if [ "$audit_mode" != 2 ]; then
      for group_id in `getent passwd |cut -f4 -d ":"`; do
        group_exists=`cat $check_file |grep -v "^#" |cut -f3 -d":" |grep "^$group_id$" |wc -l |sed "s/ //g"`
        if [ "$group_exists" = 0 ]; then
          group_fail=1
          if [ "$audit_mode" = 1 ];then
            score=`expr $score - 1`
            echo "Warning:   Group $group_id does not exist in group file [$score]"
          fi
        fi
      done
      if [ "$group_fail" != 1 ]; then
        if [ "$audit_mode" = 1 ];then
          score=`expr $score + 1`
          echo "Secure:    No non existant group issues [$score]"
        fi
      fi
    fi
  fi
}
