# audit_system_auth_no_magic_root
#
# Make sure root account isn't locked as part of account locking
#.

audit_system_auth_no_magic_root () {
  auth_string=$1
  search_string=$2
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "SuSE" ] || [ "$os_vendor" = "Ubuntu" ]; then
      check_file="/etc/pam.d/common-auth"
    fi
    if [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "CentOS" ]; then
      check_file="/etc/pam.d/system-auth"
    fi
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Auth entry not enabled in $check_file"
      total=`expr $total + 1`
      check_value=`cat $check_file |grep '^$auth_string' |grep '$search_string$' |awk '{print $5}'`
      if [ "$check_value" != "$search_string" ]; then
        if [ "$audit_mode" = "1" ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Auth entry not enabled in $check_file [$insecure Warnings]"
          funct_verbose_message "rm $temp_file" fix
          funct_verbose_message "cat $temp_file |awk '( $1 == \"auth\" && $2 == \"required\" && $3 == \"pam_deny.so\" ) { print \"auth\trequired\tpam_tally2.so onerr=fail no_magic_root\"; print $0; next };' > $check_file" fix
          funct_verbose_message "rm $temp_file" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $check_file
          echo "Setting:   Auth entry in $check_file"
          cp $check_file $temp_file
          cat $temp_file |awk '( $1 == "auth" && $2 == "required" && $3 == "pam_deny.so" ) { print "auth\trequired\tpam_tally2.so onerr=fail no_magic_root"; print $0; next };' > $check_file
          rm $temp_file
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          secure=`expr $secure + 1`
          echo "Secure:    Auth entry enabled in $check_file [$secure Passes]"
        fi
      fi
    else
      funct_restore_file $check_file $restore_dir
    fi
  fi
}
