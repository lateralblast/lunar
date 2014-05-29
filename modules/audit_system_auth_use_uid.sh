# audit_system_auth_use_uid
#
# Audit wheel Set UID
#
# The su command allows a user to run a command or shell as another user.
# The program has been superseded by sudo, which allows for more granular
# control over privileged access. Normally, the su command can be executed
# by any user. By uncommenting the pam_wheel.so statement in /etc/pam.d/su,
# the su command will only allow users in the wheel group to execute su.
#
# Refer to Section(s) 6.5 Page(s) 165-6 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.5 Page(s) 145-6 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

audit_system_auth_use_uid () {
  auth_string="auth"
  search_string="use_uid"
  check_file="/etc/pam.d/su"
  if [ "$os_name" = "Linux" ]; then
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  The use of su is restricted by sudo"
      total=`expr $total + 1`
      check_value=`cat $check_file |grep '^$auth_string' |grep '$search_string$' |awk '{print $8}'`
      if [ "$check_value" != "$search_string" ]; then
        if [ "$audit_mode" = "1" ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   The use of su is not restricted by sudo in $check_file [$insecure Warnings]"
          funct_verbose_message "cp $check_file $temp_file" fix
          funct_verbose_message "cat $temp_file |sed 's/^auth.*use_uid$/&\nauth\t\trequired\t\t\tpam_wheel.so use_uid\n/' > $check_file" fix
          funct_verbose_message "rm $temp_file" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $check_file
          echo "Setting:   The use of su to be restricted by sudo in $check_file"
          cp $check_file $temp_file
          cat $temp_file |sed 's/^auth.*use_uid$/&\nauth\t\trequired\t\t\tpam_wheel.so use_uid\n/' > $check_file
          rm $temp_file
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          secure=`expr $secure + 1`
          echo "Secure:    The use of su is restricted by sudo in $check_file [$secure Passes]"
        fi
      fi
    else
      funct_restore_file $check_file $restore_dir
    fi
  fi
}
