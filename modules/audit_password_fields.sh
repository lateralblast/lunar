# audit_password_fields
#
# Ensure Password Fields are Not Empty
# Verify System Account Default Passwords
# Ensure Password Fields are Not Empty
#
# An account with an empty password field means that anybody may log in as
# that user without providing a password at all (assuming that PASSREQ=NO
# in /etc/default/login). All accounts must have passwords or be locked.
#
# Refer to Section(s) 9.2.1  Page(s) 162-3 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.1  Page(s) 187-8 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.1  Page(s) 166   CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 13.1   Page(s) 154   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.2    Page(s) 27    CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.2.15 Page(s) 219   CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.4    Page(s) 75    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.3    Page(s) 118   CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.1  Page(s) 252   CIS Amazon Linux Benchmark v1.0.0
#.

audit_password_fields () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    funct_verbose_message "Password Fields"
    check_file="/etc/shadow"
    empty_count=0
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Password fields"
      total=`expr $total + 1`
      if [ "$os_name" = "AIX" ]; then
        empty_command="pwdck –n ALL"
      else
        empty_command="cat /etc/shadow |awk -F":" '{print $1":"$2":"}' |grep "::$" |cut -f1 -d":""
      fi
      for user_name in `$empty_command`; do
        empty_count=1
        if [ "$audit_mode" = 1 ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   No password field for $user_name in $check_file [$insecure Warnings]"
          funct_verbose_message "" fix
          funct_verbose_message "passwd -d $user_name" fix
          if [ "$os_name" = "SunOS" ]; then
            funct_verbose_message "passwd -N $user_name" fix
          fi
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $check_file
          echo "Setting:   No password for $user_name"
          passwd -d $user_name
          if [ "$os_name" = "SunOS" ]; then
            passwd -N $user_name
          fi
        fi
      done
      if [ "$empty_count" = 0 ]; then
        secure=`expr $secure + 1`
        echo "Secure:    No empty password entries"
      fi
    else
      funct_restore_file $check_file $restore_dir
    fi
  fi
}
