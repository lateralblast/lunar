# audit_system_auth_nullok
#
# Ensure null passwords are not accepted
#.

audit_system_auth_nullok () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$audit_mode" != 2 ]; then
      for check_file in etc/pam.d/common-auth /etc/pam.d/system-auth; do
        if [ -f "$check_file" ]; then
          echo "Checking:  For nullok entry in $check_file"
          total=`expr $total + 1`
          check_value=0
          check_value=`cat $check_file |grep -v '^#' |grep 'nullok' |head -1 |wc -l`
          if [ "$check_value" = 1 ]; then
            if [ "$audit_mode" = "1" ]; then
              insecure=`expr $insecure + 1`
              echo "Warning:   Found nullok entry in $check_file [$insecure Warnings]"
              funct_verbose_message "cp $check_file $temp_file" fix
              funct_verbose_message "cat $temp_file |sed 's/ nullok//' > $check_file" fix
              funct_verbose_message "rm $temp_file" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              funct_backup_file $check_file
              echo "Setting:   Removing nullok entries from $check_file"
              cp $check_file $temp_file
              cat $temp_file |sed 's/ nullok//' > $check_file
              rm $temp_file
            fi
          else
            if [ "$audit_mode" = "1" ]; then
              secure=`expr $secure + 1`
              echo "Secure:    No nullok entries in $check_file [$secure Passes]"
            fi
          fi
        fi
      done
    else
      for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do
        funct_restore_file $check_file $restore_dir
      done 
    fi
  fi
}
