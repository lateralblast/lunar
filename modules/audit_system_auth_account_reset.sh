# audit_system_auth_account_reset
#
# Reset attempt counter to 0 after number of tries have been used
#
# Lock out userIDs after n unsuccessful consecutive login attempts.
# The first set of changes are made to the main PAM configuration file
# /etc/pam.d/system-auth.
# The second set of changes are applied to the program specific PAM
# configuration file (in this case, the ssh daemon).
# The second set of changes must be applied to each program that will
# lock out userID's.
#
# Set the lockout number to the policy in effect at your site.
#
# Locking out userIDs after n unsuccessful consecutive login attempts
# mitigates brute force password attacks against your systems.
#
# Refer to Section(s) 6.3.2 Page(s) 161-2 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.3.2 Page(s) 133-4 SLES 11 Benchmark v1.0.0
#.

audit_system_auth_account_reset () {
  auth_string=$1
  search_string=$2
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "SuSE" ] || [ "$os_vendor" = "Ubuntu" ]; then
      check_file="/etc/pam.d/common-auth"
    fi
    if [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "Ubuntu" ]; then
      check_file="/etc/pam.d/system-auth"
    fi
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Account reset entry not enabled in $check_file"
      total=`expr $total + 1`
      check_value=`cat $check_file |grep '^$auth_string' |grep '$search_string$' |awk '{print $6}'`
      if [ "$check_value" != "$search_string" ]; then
        if [ "$audit_mode" = "1" ]; then
          score=`expr $score - 1`
          echo "Warning:   Account reset entry not enabled in $check_file [$score]"
          funct_verbose_message "cp $check_file $temp_file" fix
          funct_verbose_message "cat $temp_file |awk '( $1 == \"account\" && $2 == \"required\" && $3 == \"pam_permit.so\" ) { print \"auth\trequired\tpam_tally2.so onerr=fail no_magic_root reset\"; print $0; next };' > $check_file" fix
          funct_verbose_message "rm $temp_file" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $check_file
          echo "Setting:   Account reset entry in $check_file"
          cp $check_file $temp_file
          cat $temp_file |awk '( $1 == "account" && $2 == "required" && $3 == "pam_permit.so" ) { print "auth\trequired\tpam_tally2.so onerr=fail no_magic_root reset"; print $0; next };' > $check_file
          rm $temp_file
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          score=`expr $score + 1`
          echo "Secure:    Account entry enabled in $check_file [$score]"
        fi
      fi
    else
      funct_restore_file $check_file $restore_dir
    fi
  fi
}
