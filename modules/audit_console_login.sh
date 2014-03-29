# audit_console_login
#
# Privileged access to the system via the root account must be accountable
# to a particular user. The system console is supposed to be protected from
# unauthorized access and is the only location where it is considered
# acceptable # to permit the root account to login directly, in the case of
# system emergencies. This is the default configuration for Solaris.
# Use an authorized mechanism such as RBAC, the su command or the freely
# available sudo package to provide administrative access through unprivileged
# accounts. These mechanisms provide at least some limited audit trail in the
# event of problems.
# Note that in addition to the configuration steps included here, there may be
# other login services (such as SSH) that require additional configuration to
# prevent root logins via these services.
# A more secure practice is to make root a "role" instead of a user account.
# Role Based Access Control (RBAC) is similar in function to sudo, but provides
# better logging ability and additional authentication requirements. With root
# defined as a role, administrators would have to login under their account and
# provide root credentials to invoke privileged commands. This restriction also
# includes logging in to the console, except for single user mode.
#
# Refer to Section(s) 6.4 Page(s) 142-3 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.14 Page(s) 57 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 6.10 Page(s) 95-6 CIS Solaris 10 v5.1.0
#.

audit_console_login () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Root Login to System Console"
    if [ "$os_version" = "10" ]; then
      check_file="/etc/default/login"
      funct_file_value $check_file CONSOLE eq /dev/console hash
    fi
    if [ "$os_version" = "11" ]; then
      service_name="svc:/system/console-login:terma"
      funct_service $service_name disabled
      service_name="svc:/system/console-login:termb"
      funct_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Root Login to System Console"
    disable_ttys=0
    check_file="/etc/securetty"
    console_list=""
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Remote consoles"
      for console_device in `cat $check_file |grep '^tty[0-9]'`; do
        disable_ttys=1
        console_list="$console_list $console_device"
      done
      if [ "$disable_ttys" = 1 ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score - 1`
          echo "Warning:   Consoles enabled on$console_list [$score]"
          funct_verbose_message "" fix
          funct_verbose_message "cat $check_file |sed 's/tty[0-9].*//g' |grep '[a-z]' > $temp_file" fix
          funct_verbose_message "cat $temp_file > $check_file" fix
          funct_verbose_message "rm $temp_file" fix
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $check_file
          echo "Setting:   Consoles to disabled on$console_list"
          cat $check_file |sed 's/tty[0-9].*//g' |grep '[a-z]' > $temp_file
          cat $temp_file > $check_file
          rm $temp_file
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score + 1`
          echo "Secure:    No consoles enabled on tty[0-9]* [$score]"
        fi
      fi
    else
      funct_restore_file $check_file $restore_dir
    fi
  fi
}
