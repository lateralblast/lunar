# audit_shells
#
# Check that shells in /etc/shells exist
#.

audit_shells () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Shells"
    check_file="/etc/shells"
    if [ -f "$check_file" ]; then
      if [ "$audit_mode" = 2 ]; then
        funct_restore_file $check_file $restore_dir
      else
        for check_shell in `cat $check_file |grep -v '^#'`; do
          total=`expr $total + 1`
          if [ ! -f "check_shell" ]; then
            if [ "$audit_mode" = 1 ]; then
              score=`expr $score - 1`
              echo "Warning:   Shell $check_shell in $check_file does not exit [$score]"
            fi
            if [ "$audit_mode" = 0 ]; then
              temp_file="$temp_dir/shells"
              funct_backup_file $check_file
              grep -v "^$check_shell" $check_file > $temp_file
              cat $temp_file > $check_file
            fi
          fi
        done
      fi
    fi
  fi
}
