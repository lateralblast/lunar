# audit_system_accounts
#
# There are a number of accounts provided with the Solaris OS that are used to
# manage applications and are not intended to provide an interactive shell.
# It is important to make sure that accounts that are not being used by regular
# users are locked to prevent them from logging in or running an interactive
# shell. By default, Solaris sets the password field for these accounts to an
# invalid string, but it is also recommended that the shell field in the
# password file be set to "false." This prevents the account from potentially
# being used to run any commands.
#
# Refer to Section(s) 7.2 Page(s) 146-147 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 7.2 Page(s) 169 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 7.2 Page(s) 149-150 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 10.2 Page(s) 138-9 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.1 Page(s) 27 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 9.3 Page(s) 73-4 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 7.1 Page(s) 100-1 CIS Solaris 10 v5.1.0
#.

audit_system_accounts () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    funct_verbose_message "System Accounts that do not have a shell"
    check_file="/etc/passwd"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  System accounts have valid shells"
      for user_name in `egrep -v "^\+" /etc/passwd | awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $3<500 && $7!="/sbin/nologin" && $7!="/bin/false" ) {print $1}'`; do
        shadow_field=`grep "$user_name:" /etc/shadow |egrep -v "\*|\!\!|NP|UP|LK" |cut -f1 -d:`;
        if [ "$shadow_field" = "$user_name" ]; then
          echo "Warning:   System account $user_name has an invalid shell but the account is disabled"
        else
          if [ "$audit_mode" = 1 ]; then
            total=`expr $total + 1`
            score=`expr $score - 1`
            echo "Warning:   System account $user_name has an invalid shell"
            funct_verbose_message "" fix
            if [ "$os_name" = "FreeBSD" ]; then
              funct_verbose_message "pw moduser $user_name -s /sbin/nologin" fix
            else
              funct_verbose_message "usermod -s /sbin/nologin $user_name" fix
            fi
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   System account $user_name to have shell /sbin/nologin"
            funct_backup_file $check_file
            if [ "$os_name" = "FreeBSD" ]; then
              pw moduser $user_name -s /sbin/nologin
            else
              usermod -s /sbin/nologin $user_name
            fi
          fi
        fi
      done
    else
      funct_restore_file $check_file $restore_dir
    fi
  fi
}
