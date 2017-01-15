# audit_super_users
#
# Any account with UID 0 has superuser privileges on the system.
# This access must be limited to only the default root account
# and only from the system console.
#
# Refer to Section(s) 9.2.5 Page(s) 190-1  CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.5 Page(s) 165    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.5 Page(s) 168    CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.2.5 Page(s) 278    CIS Red Hat Linux 7 Benchmark v2.1.0
# Refer to Section(s) 13.5  Page(s) 156-7  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.6   Page(s) 28     CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.2.8 Page(s) 32     CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9-5   Page(s) 75-6   CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.5   Page(s) 119-20 CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.5 Page(s) 256    CIS Amazon Linux Benchmark v2.0.0
#.

audit_super_users() {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    if [ "$os_name" = "AIX" ]; then
      funct_chuser_check su true sugroups system root
    else
      funct_verbose_message "Accounts with UID 0"
      if [ "$audit_mode" != 2 ]; then
        echo "Checking:  Super users other than root"
        total=`expr $total + 1`
        for user_name in `awk -F: '$3 == "0" { print $1 }' /etc/passwd |grep -v root`; do
          echo "$user_name"
          if [ "$audit_mode" = 1 ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   UID 0 for $user_name [$insecure Warnings]"
            funct_verbose_message "" fix
            funct_verbose_message "userdel $user_name" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            check_file="/etc/shadow"
            funct_backup_file $check_file
            check_file="/etc/passwd"
            backup_file="$work_dir$check_file"
            funct_backup_file $check_file
            echo "Removing:  Account $user_name it UID 0"
            userdel $user_name
          fi
        done
        if [ "$user_name" = "" ]; then
          if [ "$audit_mode" = 1 ]; then
            secure=`expr $secure + 1`
            echo "Secure:    No accounts other than root have UID 0 [$secure Passes]"
          fi
        fi
      else
        check_file="/etc/shadow"
        funct_restore_file $check_file $restore_dir
        check_file="/etc/passwd"
        funct_restore_file $check_file $restore_dir
      fi
    fi
  fi
}
