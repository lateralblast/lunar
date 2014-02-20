# audit_rsa_securid_pam
#
# Check that RSA is installed
#.

audit_rsa_securid_pam () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "SunOS" ]; then
    check_file="/etc/sd_pam.conf"
    if [ -f "$check_file" ]; then
      search_string="pam_securid.so"
      if [ "$os_name" = "SunOS" ]; then
        check_file="/etc/pam.conf"
        if [ -f "$check_file" ]; then
          check_value=`cat $check_file |grep "$search_string" |awk '{print  $3}'`
        fi
      fi
      if [ "$os_name" = "Linux" ]; then
        check_file="/etc/pam.d/sudo"
        if [ -f "$check_file" ]; then
          check_value=`cat $check_file |grep "$search_string" |awk '{print  $4}'`
        fi
      fi
      funct_verbose_message "RSA SecurID PAM Agent Configuration"
      if [ "$audit_mode" != 2 ]; then
        echo "Checking:  RSA SecurID PAM Agent is enabled for sudo"
        total=`expr $total + 1`
        if [ "$check_value" != "$search_string" ]; then
          score=`expr $score - 1`
          if [ "$audit_mode" = 1 ]; then
            echo "Warning:   RSA SecurID PAM Agent is not enabled for sudo [$score]"
            funct_verbose_message "" fix
            if [ "$os_name" = "Linux" ]; then
              funct_verbose_message "cat $check_file |sed 's/^auth/#\&/' > $temp_file" fix
              funct_verbose_message "cat $temp_file > $check_file" fix
              funct_verbose_message "echo \"auth\trequired\tpam_securid.so reserve\" >> $check_file" fix
              funct_verbose_message "rm $temp_file" fix
            fi
            if [ "$os_name" = "SunOS" ]; then
              funct_verbose_message "echo \"sudo\tauth\trequired\tpam_securid.so reserve\" >> $check_file" fix
            fi
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            funct_backup_file $check_file
            echo "Fixing:    Configuring RSA SecurID PAM Agent for sudo"
            if [ "$os_name" = "Linux" ]; then
              cat $check_file |sed 's/^auth/#\&/' > $temp_file
              cat $temp_file > $check_file
              echo "auth\trequired\tpam_securid.so reserve" >> $check_file
              rm $temp_file
            fi
            if [ "$os_name" = "SunOS" ]; then
              echo "sudo\tauth\trequired\tpam_securid.so reserve" >> $check_file
            fi
            #echo "Removing:  Configuring logrotate"
            #cat $check_file |sed 's,.*{,$search_string {,' > $temp_file
            #cat $temp_file > $check_file
            #rm $temp_file
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score + 1`
            echo "Secure:    RSA SecurID PAM Agent is configured for sudo [$score]"
          fi
        fi
      else
        funct_restore_file $check_file $restore_dir
      fi
    fi
  fi
}
