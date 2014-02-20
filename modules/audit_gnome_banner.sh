# audit_gnome_banner
#
# Create Warning Banner for GNOME Users
#.

audit_gnome_banner () {
  if [ "$os_name" = "SunOS" ]; then
    total=`expr $total + 1`
    if [ "$os_version" = "10" ]; then
      funct_verbose_message"Gnome Warning Banner"
      check_file="/etc/X11/gdm.conf"
      funct_file_value $check_file Welcome eq "Authorised users only" hash
    fi
    if [ "$os_version" = "11" ]; then
      funct_verbose_message "Gnome Warning Banner"
      check_file="/etc/gdm/Init/Default"
      if [ "$audit_mode" != 2 ]; then
        if [ -f "$check_file" ]; then
          gdm_check=`cat $check_file |grep 'Security Message' |cut -f3 -d"="`
          if [ "$gdm_check" != "/etc/issue" ]; then
            if [ "$audit_mode" = 1 ]; then
              score=`expr $score - 1`
              echo "Warning:   Warning banner not found in $check_file [$score]"
              funct_verbose_message "" fix
              funct_verbose_message "echo \"   --title=\"Security Message\" --filename=/etc/issue\" >> $check_file" fix
              funct_verbose_message "" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              funct_backup_file $check_file
              echo "Setting:   Warning banner in $check_file"
              echo "   --title=\"Security Message\" --filename=/etc/issue" >> $check_file
              if [ "$os_version" = "10" ]; then
                pkgchk -f -n -p $check_file 2> /dev/null
              else
                pkg fix `pkg search $check_file |grep pkg |awk '{print $4}'`
              fi
            fi
          fi
          if [ "$file_entry" = "" ]; then
            if [ "$audit_mode" = 1 ]; then
              score=`expr $score + 1`
              echo "Secure:    Warning banner in $check_file [$score]"
            fi
          fi
        else
          funct_restore_file $check_file $restore_dir
        fi
      fi
    fi
  fi
}
