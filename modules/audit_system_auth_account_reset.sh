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
# Refer to Section(s) 9.3.2 Page(s) 133-4 CIS SLES 11 Benchmark v1.0.0
#.

audit_system_auth_account_reset () {
  auth_string=$1
  search_string=$2
  if [ "$os_name" = "Linux" ]; then
    if [ "$audit_mode" != 2 ]; then
      for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do 
        if [ -f "$check_file" ]; then
          echo "Checking:  Account reset entry not enabled in $check_file"
          total=`expr $total + 1`
          check_value=`cat $check_file |grep '^$auth_string' |grep '$search_string$' |awk '{print $6}'`
          if [ "$check_value" != "$search_string" ]; then
            if [ "$audit_mode" = "1" ]; then
              insecure=`expr $insecure + 1`
              echo "Warning:   Account reset entry not enabled in $check_file [$insecure Warnings]"
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
              secure=`expr $secure + 1`
              echo "Secure:    Account entry enabled in $check_file [$secure Passes]"
            fi
          fi
        done
      fi
    else
      for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do 
        funct_restore_file $check_file $restore_dir
      done 
    fi
  fi
}
