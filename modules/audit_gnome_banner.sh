# audit_gnome_banner
#
# Create Warning Banner for GNOME Users
#
# Refer to Section(s) 8.3  Page(s) 151   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 8.2  Page(s) 174-5 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 8.3  Page(s) 154-5 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 11.3 Page(s) 143-4 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.3  Page(s) 69-70 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 8.3  Page(s) 113-4 CIS Solaris 10 Benchmark v5.1.0
#.

audit_gnome_banner () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Gnome Warning Banner"
    if [ "$os_name" = "SunOS" ]; then
      total=`expr $total + 1`
      if [ "$os_version" = "10" ]; then
        check_file="/etc/X11/gdm.conf"
        funct_file_value $check_file Welcome eq "Authorised users only" hash
      fi
      if [ "$os_version" = "11" ]; then
        check_file="/etc/gdm/Init/Default"
        if [ "$audit_mode" != 2 ]; then
          if [ -f "$check_file" ]; then
            gdm_check=`cat $check_file |grep 'Security Message' |cut -f3 -d"="`
            if [ "$gdm_check" != "/etc/issue" ]; then
              if [ "$audit_mode" = 1 ]; then
                insecure=`expr $insecure + 1`
                echo "Warning:   Warning banner not found in $check_file [$insecure Warnings]"
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
                secure=`expr $secure + 1`
                echo "Secure:    Warning banner in $check_file [$insecure Warnings]"
              fi
            fi
          else
            funct_restore_file $check_file $restore_dir
          fi
        fi
      fi
    fi
    gconf_bin=`which gconftool-2 2> /dev/null`
    if [ "$os_name" = "Linux" ] && [ -f "$gconf_bin" ]; then
      warning_message="Authorised users only"
      actual_value=`gconftool-2 --get /apps/gdm/simple-greeter/banner_message_text`
      log_file="gnome_banner_warning"
      if [ "$audit_mode" != 2 ]; then
        if [ "$actual_value" != "$warning_message" ]; then
          if [ "$audit_mode" = 1 ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   Warning banner not found in $check_file [$insecure Warnings]"
            funct_verbose_message "" fix
            funct_verbose_message "gconftool-2 -direct -config-source=xml:readwrite:$HOME/.gconf -t string -s /apps/gdm/simple-greeter/banner_message_text \"$warning_message\"" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   Warning banner to \"$warning_message\""
            log_file="$work_dir/$log_file"
            echo "$actual_value" > $log_file
            gconftool-2 -direct -config-source=xml:readwrite:$HOME/.gconf -t string -s /apps/gdm/simple-greeter/banner_message_text \"$warning_message\"
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Warning banner is set to \"$warning_message\" [$insecure Warnings]"
          fi
        fi
      else
        log_file="$restore_dir/$log_file"
        if [ -f "$log_file" ]; then
          restore_value=`cat $log_file`
          if [ "$restore_value" != "$actual_value" ]; then
            echo "Restoring: Warning banner to $previous_value"
            gconftool-2 -direct -config-source=xml:readwrite:$HOME/.gconf -t string -s /apps/gdm/simple-greeter/banner_message_text "$restore_value"
          fi
        fi
      fi
      actual_value=`gconftool-2 --get /apps/gdm/simple-greeter/banner_message_enable`
      log_file="gnome_banner_status"
      if [ "$audit_mode" != 2 ]; then
        if [ "$actual_value" != "true" ]; then
          if [ "$audit_mode" = 1 ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   Warning banner not found in $check_file [$insecure Warnings]"
            funct_verbose_message "" fix
            funct_verbose_message "gconftool-2 -direct -config-source=xml:readwrite:$HOME/.gconf -type bool -set /apps/gdm/simple-greeter/banner_message_enable true" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   Warning banner to \"$warning_message\""
            log_file="$work_dir/$log_file"
            echo "$actual_value" > $log_file
            gconftool-2 -direct -config-source=xml:readwrite:$HOME/.gconf -type bool -set /apps/gdm/simple-greeter/banner_message_enable true
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Warning banner is set to \"$warning_message\" [$insecure Warnings]"
          fi
        fi
      else
        log_file="$restore_dir/$log_file"
        if [ -f "$log_file" ]; then
          restore_value=`cat $log_file`
          if [ "$restore_value" != "$actual_value" ]; then
            echo "Restoring: Warning banner to $previous_value"
            gconftool-2 -direct -config-source=xml:readwrite:$HOME/.gconf -type bool -set /apps/gdm/simple-greeter/banner_message_enable "$restore_value"
          fi
        fi
      fi
    fi
  fi
}
