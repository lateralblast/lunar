# audit_pam_gdm_autologin
#
# As automatic logins are a known security risk for other than "kiosk" types
# of systems, GNOME automatic login should be disabled in pam.conf(4).
#
# Refer to Section(s) 16.11 Page(s) 54-5 Solaris 11.1 Benchmark v1.0.0
#.

audit_pam_gdm_autologin () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "11" ]; then
      funct_verbose_message "Gnome Autologin"
      check_file="/etc/pam.d/gdm-autologin"
      temp_file="$temp_dir/gdm-autologin"
      if [ "$audit_mode" = 2 ]; then
        funct_restore_file $check_file $restore_dir
      else
        echo "Checking:  Gnome Autologin is not enabled"
      fi
      total=`expr $total + 1`
      if [ "$audit_mode" != 2 ]; then
        gdm_check=`cat $check_file |grep -v "^#" |grep "^gdm-autologin" |head -1 |wc -l`
        if [ "$gdm_check" != 0 ]; then
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score - 1`
            echo "Warning:   Gnome Autologin is enabled [$score]"
            funct_verbose_message "" fix
            funct_verbose_message "cat $check_file |sed 's/^gdm-autologin/#&/g' > $temp_file"
            funct_verbose_message "cat $temp_file > $check_file" fix
            funct_verbose_message "rm $temp_file" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            funct_backup_file $check_file
            cat $check_file |sed 's/^gdm-autologin/#&/g' > $temp_file
            cat $temp_file > $check_file
            rm $temp_file
          fi
        else
          if [ "$audit_mode" = 1 ];then
            score=`expr $score + 1`
            echo "Secure:    No members in shadow group [$score]"
          fi
        fi
      fi
    fi
  fi
}
