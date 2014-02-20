# audit_system_auth_use_uid
#
# Audit wheel Set UID
#.

audit_system_auth_use_uid () {
  auth_string=$1
  search_string=$2
  check_file="/etc/pam.d/su"
  if [ "$os_name" = "Linux" ]; then
    if [ "$linux_dist" = "redhat" ]; then
      check_file="/etc/pam.d/system-auth"
    fi
    if [ "$linux_dist" = "debian" ] || [ "$linux_dist" = "suse" ]; then
      check_file="/etc/pam.d/common-auth"
    fi
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Lockout for failed password attempts enabled in $check_file"
      total=`expr $total + 1`
      check_value=`cat $check_file |grep '^$auth_string' |grep '$search_string$' |awk '{print $8}'`
      if [ "$check_value" != "$search_string" ]; then
        if [ "$audit_mode" = "1" ]; then
          score=`expr $score - 1`
          echo "Warning:   Lockout for failed password attempts not enabled in $check_file [$score]"
          funct_verbose_message "cp $check_file $temp_file" fix
          funct_verbose_message "cat $temp_file |sed 's/^auth.*use_uid$/&\nauth\t\trequired\t\t\tpam_wheel.so use_uid\n/' > $check_file" fix
          funct_verbose_message "rm $temp_file" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $check_file
          echo "Setting:   Password minimum length in $check_file"
          cp $check_file $temp_file
          cat $temp_file |sed 's/^auth.*use_uid$/&\nauth\t\trequired\t\t\tpam_wheel.so use_uid\n/' > $check_file
          rm $temp_file
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          score=`expr $score + 1`
          echo "Secure:    Lockout for failed password attempts enabled in $check_file [$score]"
        fi
      fi
    else
      funct_restore_file $check_file $restore_dir
    fi
  fi
}
