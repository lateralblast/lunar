# audit_system_auth_password_policy
#
# Refer to Section(s) 6.3.2 Page(s) 139-140 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.3.2 Page(s) 142-3   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 9.3.1 Page(s) 132-3   CIS SLES 11 Benchmark v1.0.0
#.

audit_system_auth_password_policy () {
  auth_string=$1
  search_string=$2
  search_value=$3
  if [ "$os_name" = "Linux" ]; then
    if [ "$audit_mode" != 2 ]; then
      for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do
        if [ -f "$check_file" ]; then
          verbose_message "Password $search_string is set to $search_value in $check_file"
          check_value=$( grep '^$auth_string' $check_file | grep '$search_string$' | awk -F '$search_string=' '{print $2}' | awk '{print $1}' )
          if [ "$check_value" != "$search_value" ]; then
            if [ "$audit_mode" = "1" ]; then
              increment_insecure "Password $search_string is not set to $search_value in $check_file"
              verbose_message "cp $check_file $temp_file" fix
              verbose_message "cat $temp_file |awk '( $1 == \"password\" && $2 == \"requisite\" && $3 == \"pam_cracklib.so\" ) { print $0  \" dcredit=-1 lcredit=-1 ocredit=-1 ucredit=-1 minlen=9\"; next }; { print }' > $check_file" fix
              verbose_message "rm $temp_file" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              backup_file $check_file
              verbose_message "Setting:   Password $search_string to $search_value in $check_file"
              cp $check_file $temp_file
              cat $temp_file |awk '( $1 == "password" && $2 == "requisite" && $3 == "pam_cracklib.so" ) { print $0  " dcredit=-1 lcredit=-1 ocredit=-1 ucredit=-1 minlen=9"; next }; { print }' > $check_file
              rm $temp_file
            fi
          else
            if [ "$audit_mode" = "1" ]; then
              increment_secure "Password $search_string set to $search_value in $check_file"
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
