# audit_system_auth_password_policy
#
# Audit password policies
#
# Refer to Section(s) 6.3.2 Page(s) 139-140 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.3.2 Page(s) 142-3 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 9.3.1 Page(s) 132-3 SLES 11 Benchmark v1.0.0
#.

audit_system_auth_password_policy () {
  auth_string=$1
  search_string=$2
  search_value=$3
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "SuSE" ] || [ "$os_vendor" = "Ubuntu" ]; then
      check_file="/etc/pam.d/common-auth"
    fi
    if [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "CentOS" ]; then
      check_file="/etc/pam.d/system-auth"
    fi
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Password $search_string is set to $search_value in $check_file"
      total=`expr $total + 1`
      check_value=`cat $check_file |grep '^$auth_string' |grep '$search_string$' |awk -F '$search_string=' '{print $2}' |awk '{print $1}'`
      if [ "$check_value" != "$search_value" ]; then
        if [ "$audit_mode" = "1" ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Password $search_string is not set to $search_value in $check_file [$insecure Warnings]"
          funct_verbose_message "cp $check_file $temp_file" fix
          funct_verbose_message "cat $temp_file |awk '( $1 == \"password\" && $2 == \"requisite\" && $3 == \"pam_cracklib.so\" ) { print $0  \" dcredit=-1 lcredit=-1 ocredit=-1 ucredit=-1 minlen=9\"; next }; { print }' > $check_file" fix
          funct_verbose_message "rm $temp_file" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $check_file
          echo "Setting:   Password $search_string to $search_value in $check_file"
          cp $check_file $temp_file
          cat $temp_file |awk '( $1 == "password" && $2 == "requisite" && $3 == "pam_cracklib.so" ) { print $0  " dcredit=-1 lcredit=-1 ocredit=-1 ucredit=-1 minlen=9"; next }; { print }' > $check_file
          rm $temp_file
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          secure=`expr $secure + 1`
          echo "Secure:    Password $search_string set to $search_value in $check_file [$secure Passes]"
        fi
      fi
    else
      funct_restore_file $check_file $restore_dir
    fi
  fi
}
