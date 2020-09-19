# audit_shells
#
# Check that shells in /etc/shells exist
#.

audit_shells () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Shells"
    check_file="/etc/shells"
    if [ -f "$check_file" ]; then
      if [ "$audit_mode" = 2 ]; then
        restore_file $check_file $restore_dir
      else
        for check_shell in $( grep -v '^#' $check_file ); do
          if [ ! -f "check_shell" ]; then
            if [ "$audit_mode" = 1 ]; then
              increment_insecure "Shell $check_shell in $check_file does not exit"
            fi
            if [ "$audit_mode" = 0 ]; then
              temp_file="$temp_dir/shells"
              backup_file $check_file
              grep -v "^$check_shell" $check_file > $temp_file
              cat $temp_file > $check_file
            fi
          fi
        done
      fi
    fi
  fi
}
