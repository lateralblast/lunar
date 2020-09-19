# audit_wheel_sudo
#
# Check wheel group settings in sudoers
#.

audit_wheel_sudo () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    verbose_message "Sudoers group settings"
    for check_dir in /etc /usr/local/etc /usr/sfw/etc /opt/csw/etc; do
      check_dir="$check_dir/sudoers.d"
      if [ -d "$check_dir" ]; then
        for check_file in $( find $check_dir -type f ); do
          check_file_perms $check_file 0440 root root
          if [ "$audit_mode" != 2 ]; then
            w_groups=$( grep NOPASSWD $check_file | grep ALL | grep -v '^#' | awk '{print $1}' )
            for w_group in $w_groups ; do
              if [ "$ansible" = 1 ]; then
                echo ""
                echo "- name: Checking NOPASSWD for $w_group in $check_file"
                echo "  lineinfile:"
                echo "    path: $check_file"
                echo "    regexp: ''(.*NOPASSWD.*)'"
                echo "    replace: '#\1'"
                echo ""
              fi
              if [ "$audit_mode" = 1 ]; then
                increment_insecure "Group $w_group does not require password to escalate privileges"
                verbose_message "" fix
                verbose_message "cat $check_file |sed 's/^\(%.*NOPASSWD.*\)/#\1/g' > $temp_file ; cat $temp_file > $check_file" fix
                verbose_message "" fix
              fi
              if [ "$audit_mode" = 0 ]; then
                backup_file $check_file
                verbose_message "Setting:   Disabling $w_group NOPASSWD entry"
              fi
            done
          else
            restore_file $check_file $restore_dir
          fi
        done
      fi
      check_file="$check_dir/sudoers"
      if [ -f "$check_file" ]; then
        check_file_perms $check_file 0440 root root
        if [ "$audit_mode" != 2 ]; then
          w_groups=$( grep NOPASSWD $check_file | grep ALL | grep -v '^#' | awk '{print $1}' )
          for w_group in $w_groups ; do
            if [ "$ansible" = 1 ]; then
              echo ""
              echo "- name: Checking NOPASSWD for $w_group in $check_file"
              echo "  lineinfile:"
              echo "    path: $check_file"
              echo "    regexp: ''(.*NOPASSWD.*)'"
              echo "    replace: '#\1'"
              echo ""
            fi
            if [ "$audit_mode" = 1 ]; then
              increment_insecure "Group $w_group does not require password to escalate privileges"
               verbose_message "" fix
               verbose_message "cat $check_file |sed 's/^\(%.*NOPASSWD.*\)/#\1/g' > $temp_file ; cat $temp_file > $check_file" fix
               verbose_message "" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              backup_file $check_file
              verbose_message "Setting:   Disabling $w_group NOPASSWD entry"
            fi
          done
        else
          restore_file $check_file $restore_dir
        fi
      fi
    done
  fi
}
