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
#.

audit_system_accounts () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
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
            funct_verbose_message "usermod -s /sbin/nologin $user_name" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   System account $user_name to have shell /sbin/nologin"
            funct_backup_file $check_file
            usermod -s /sbin/nologin $user_name
          fi
        fi
      done
    else
      funct_restore_file $check_file $restore_dir
    fi
  fi
}
