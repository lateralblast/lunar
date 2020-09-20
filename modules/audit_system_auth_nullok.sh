# audit_system_auth_nullok
#
# Ensure null passwords are not accepted
#.

audit_system_auth_nullok () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$audit_mode" != 2 ]; then
      for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do
        if [ -f "$check_file" ]; then
          verbose_message "For nullok entry in $check_file"
          check_value=0
          check_value=$( grep -v '^#' $check_file | grep 'nullok' | head -1 | wc -l )
          if [ "$check_value" = 1 ]; then
            if [ "$audit_mode" = "1" ]; then
              increment_insecure "Found nullok entry in $check_file"
              verbose_message "cp $check_file $temp_file" fix
              verbose_message "cat $temp_file |sed 's/ nullok//' > $check_file" fix
              verbose_message "rm $temp_file" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              backup_file $check_file
              verbose_message "Setting:   Removing nullok entries from $check_file"
              cp $check_file $temp_file
              cat $temp_file |sed 's/ nullok//' > $check_file
              rm $temp_file
            fi
          else
            if [ "$audit_mode" = "1" ]; then
              increment_secure "No nullok entries in $check_file"
            fi
          fi
        fi
      done
    else
      for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do
        restore_file $check_file $restore_dir
      done 
    fi
  fi
}
