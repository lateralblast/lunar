# audit_system_auth_password_history
#
# Audit the number of remembered passwords
#
# The /etc/security/opasswd file stores the users' old passwords and can be
# checked to ensure that users are not recycling recent passwords.
# Forcing users not to reuse their past 5 passwords make it less likely that
# an attacker will be able to guess the password.
#
# Refer to Section(s) 6.3.4 Page(s) 141-2 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.3.4 Page(s) 144-5 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

audit_system_auth_password_history () {
  auth_string=$1
  search_string=$2
  search_value=$3
  if [ "$os_name" = "Linux" ]; then
    check_file="/etc/security/opasswd"
    funct_file_exists $check_file
    funct_check_perms $check_file 0600 root root
    if [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "SuSE" ] || [ "$os_vendor" = "Ubuntu" ]; then
      check_file="/etc/pam.d/common-auth"
    fi
    if [ "$os_vendor" = "Red" ] || [ "$os_name" = "CentOS" ]; then
      check_file="/etc/pam.d/system-auth"
    fi
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Password entry $search_string set to $search_value in $check_file"
      total=`expr $total + 1`
      check_value=`cat $check_file |grep '^$auth_string' |grep '$search_string$' |awk -F '$search_string=' '{print $2}' |awk '{print $1}'`
      if [ "$check_value" != "$search_value" ]; then
        if [ "$audit_mode" = "1" ]; then
          score=`expr $score - 1`
          echo "Warning:   Password entry $search_string is not set to $search_value in $check_file [$score]"
          funct_verbose_message "cp $check_file $temp_file" fix
          funct_verbose_message "cat $temp_file |awk '( $1 == \"password\" && $3 == \"pam_unix.so\" ) { print $0 \" $search_string=$search_value\"; next };' > $check_file" fix
          funct_verbose_message "rm $temp_file" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $check_file
          echo "Setting:   Password entry in $check_file"
          cp $check_file $temp_file
          cat $temp_file |awk '( $1 == "password" && $3 == "pam_unix.so" ) { print $0 " $search_string=$search_value"; next };' > $check_file
          rm $temp_file
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          score=`expr $score + 1`
          echo "Secure:    Password entry $search_string set to $search_value in $check_file [$score]"
        fi
      fi
    else
      funct_restore_file $check_file $restore_dir
    fi
  fi
}
