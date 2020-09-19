# audit_system_auth_password_history
#
# Refer to Section(s) 6.3.4 Page(s) 141-2 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.3.4 Page(s) 144-5 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 5.3.3 Page(s) 242   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 5.3.3 Page(s) 233   CIS Amazon Linux Benchmark v1.2.0
# Refer to Section(s) 9.3.3 Page(s) 134   CIS SLES 11 Benchmark v1.0.0
#.

audit_system_auth_password_history () {
  auth_string=$1
  search_string=$2
  search_value=$3
  if [ "$os_name" = "Linux" ]; then
    check_file="/etc/security/opasswd"
    check_file_exists $check_file
    check_file_perms $check_file 0600 root root
    for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do
      if [ -f "$check_file" ]; then
        if [ "$audit_mode" != 2 ]; then
          verbose_message "Password entry $search_string set to $search_value in $check_file"
          check_value=$( grep '^$auth_string' $check_file | grep '$search_string$' | awk -F '$search_string=' '{print $2}' | awk '{print $1}' )
          if [ "$check_value" != "$search_value" ]; then
            if [ "$audit_mode" = "1" ]; then
              increment_insecure "Password entry $search_string is not set to $search_value in $check_file"
              verbose_message "cp $check_file $temp_file" fix
              verbose_message "cat $temp_file |awk '( $1 == \"password\" && $3 == \"pam_unix.so\" ) { print $0 \" $search_string=$search_value\"; next };' > $check_file" fix
              verbose_message "rm $temp_file" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              backup_file $check_file
              verbose_message "Setting:   Password entry in $check_file"
              cp $check_file $temp_file
              cat $temp_file |awk '( $1 == "password" && $3 == "pam_unix.so" ) { print $0 " $search_string=$search_value"; next };' > $check_file
              rm $temp_file
            fi
          else
            if [ "$audit_mode" = "1" ]; then
              increment_secure "Password entry $search_string set to $search_value in $check_file"
            fi
          fi
        else
          for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do
            restore_file $check_file $restore_dir
          done 
        fi
      fi
    done
  fi
}
