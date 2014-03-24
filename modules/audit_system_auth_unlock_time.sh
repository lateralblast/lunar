# audit_system_auth_unlock_time
#
# Audit time before account is unlocked after unsuccesful tries
#
# Lock out userIDs after n unsuccessful consecutive login attempts.
# The first sets of changes are made to the main PAM configuration files
# /etc/pam.d/system-auth and /etc/pam.d/password-auth. The second set of
# changes are applied to the program specific PAM configuration file
# (in this case, the ssh daemon). The second set of changes must be applied
# to each program that will lock out userID's.
# Set the lockout number to the policy in effect at your site.
#
# Refer to Section 6.3.3 Page(s) 139-140 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_system_auth_unlock_time () {
  auth_string=$1
  search_string=$2
  search_value=$3
  if [ "$os_name" = "Linux" ]; then
    if [ "$linux_dist" = "redhat" ]; then
      check_file="/etc/pam.d/system-auth"
    fi
    if [ "$linux_dist" = "debian" ] || [ "$linux_dist" = "suse" ]; then
      check_file="/etc/pam.d/common-auth"
    fi
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Lockout time for failed password attempts enabled in $check_file"
      total=`expr $total + 1`
      check_value=`cat $check_file |grep '^$auth_string' |grep '$search_string$' |awk -F '$search_string=' '{print $2}' |awk '{print $1}'`
      if [ "$check_value" != "$search_string" ]; then
        if [ "$audit_mode" = "1" ]; then
          score=`expr $score - 1`
          echo "Warning:   Lockout time for failed password attempts not enabled in $check_file [$score]"
          funct_verbose_message "cp $check_file $temp_file" fix
          funct_verbose_message "cat $temp_file |sed 's/^auth.*pam_env.so$/&\nauth\t\trequired\t\t\tpam_faillock.so preauth audit silent deny=5 unlock_time=900\nauth\t\t[success=1 default=bad]\t\t\tpam_unix.so\nauth\t\t[default=die]\t\t\tpam_faillock.so authfail audit deny=5 unlock_time=900\nauth\t\tsufficient\t\t\tpam_faillock.so authsucc audit deny=5 $search_string=$search_value\n/' > $check_file" fix
          funct_verbose_message "rm $temp_file" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $check_file
          echo "Setting:   Password minimum length in $check_file"
          cp $check_file $temp_file
          cat $temp_file |sed 's/^auth.*pam_env.so$/&\nauth\t\trequired\t\t\tpam_faillock.so preauth audit silent deny=5 unlock_time=900\nauth\t\t[success=1 default=bad]\t\t\tpam_unix.so\nauth\t\t[default=die]\t\t\tpam_faillock.so authfail audit deny=5 unlock_time=900\nauth\t\tsufficient\t\t\tpam_faillock.so authsucc audit deny=5 $search_string=$search_value\n/' > $check_file
          rm $temp_file
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          score=`expr $score + 1`
          echo "Secure:    Lockout time for failed password attempts enabled in $check_file [$score]"
        fi
      fi
    else
      funct_restore_file $check_file $restore_dir
    fi
  fi
}
