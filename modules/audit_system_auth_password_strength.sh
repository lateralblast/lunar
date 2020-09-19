# audit_system_auth_password_strength
#
#.

audit_system_auth_password_strength () {
  auth_string=$1
  search_string=$2
  if [ "$os_name" = "Linux" ]; then
    if [ "$audit_mode" != 2 ]; then
      for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do
        if [ -f "$check_file" ]; then
          verbose_message "Password minimum strength enabled in $check_file"
          check_value=$( grep '^$auth_string' $check_file | grep '$search_string$' | awk '{print $8}' )
          if [ "$check_value" != "$search_string" ]; then
            if [ "$audit_mode" = "1" ]; then
              increment_insecure "Password strength settings not enabled in $check_file"
              verbose_message "cp $check_file $temp_file" fix
              verbose_message "cat $temp_file |sed 's/^password.*pam_deny.so$/&\npassword\t\trequisite\t\t\tpam_passwdqc.so min=disabled,disabled,16,12,8/' > $check_file" fix
              verbose_message "rm $temp_file" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              backup_file $check_file
              verbose_message "Setting:   Password minimum length in $check_file"
              cp $check_file $temp_file
              cat $temp_file |sed 's/^password.*pam_deny.so$/&\npassword\t\trequisite\t\t\tpam_passwdqc.so min=disabled,disabled,16,12,8/' > $check_file
              rm $temp_file
            fi
          else
            if [ "$audit_mode" = "1" ]; then
              increment_secure "Password strength settings enabled in $check_file"
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
