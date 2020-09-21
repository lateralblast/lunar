# audit_gnome_banner
#
# Create Warning Banner for GNOME Users
#
# Refer to Section(s) 8.3   Page(s) 151   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 8.2   Page(s) 174-5 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 8.3   Page(s) 154-5 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 11.3  Page(s) 143-4 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.7.2 Page(s) 84-5  CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 8.3   Page(s) 69-70 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 8.3   Page(s) 113-4 CIS Solaris 10 Benchmark v5.1.0
#.

audit_gnome_banner () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Gnome Warning Banner"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        check_file="/etc/X11/gdm.conf"
        check_file_value is $check_file Welcome eq "Authorised users only" hash
      fi
      if [ "$os_version" = "11" ]; then
        check_file="/etc/gdm/Init/Default"
        if [ "$audit_mode" != 2 ]; then
          if [ -f "$check_file" ]; then
            gdm_check=$( grep 'Security Message' $check_file | cut -f3 -d"=" )
            if [ "$gdm_check" != "/etc/issue" ]; then
              if [ "$audit_mode" = 1 ]; then
                increment_insecure "Warning banner not found in $check_file"
                verbose_message "" fix
                verbose_message "echo \"   --title=\"Security Message\" --filename=/etc/issue\" >> $check_file" fix
                verbose_message "" fix
              fi
              if [ "$audit_mode" = 0 ]; then
                backup_file $check_file
                verbose_message "Setting:   Warning banner in $check_file"
                echo "   --title=\"Security Message\" --filename=/etc/issue" >> $check_file
                if [ "$os_version" = "10" ]; then
                  pkgchk -f -n -p $check_file 2> /dev/null
                else
                  pkg fix $( pkg search $check_file | grep pkg | awk '{print $4}' )
                fi
              fi
            fi
            if [ "$file_entry" = "" ]; then
              if [ "$audit_mode" = 1 ]; then
                increment_secure "Warning banner in $check_file"
              fi
            fi
          else
            restore_file $check_file $restore_dir
          fi
        fi
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      check_file="/etc/dconf/profile/gdm"
      if [ -f "$check_file" ]; then
        check_file_value is $check_file user-db colon user hash
        check_file_value is $check_file system-db colon gdm hash
        check_file_value is $check_file file-db colon /usr/share/gdm/greeter-dconf-defaults hash
      fi
      check_file="/etc/dconf/db/gdm.d/01-banner-message"
      if [ -f "$check_file" ]; then
        check_file_value is $check_file banner-message-enable eq true hash
        check_file_value is $check_file banner-message-text eq "Authorized uses only. All activity may be monitored and reported." hash
      fi
    fi
    gconf_bin=$( command -v gconftool-2 2> /dev/null )
    if [ "$os_name" = "Linux" ] && [ -f "$gconf_bin" ]; then
      warning_message="Authorised users only"
      actual_value=$( gconftool-2 --get /apps/gdm/simple-greeter/banner_message_text )
      log_file="gnome_banner_warning"
      if [ "$audit_mode" != 2 ]; then
        if [ "$actual_value" != "$warning_message" ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "Warning banner not found in $check_file"
            verbose_message "" fix
            verbose_message "gconftool-2 -direct -config-source=xml:readwrite:$HOME/.gconf -t string -s /apps/gdm/simple-greeter/banner_message_text \"$warning_message\"" fix
            verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            verbose_message "Setting:   Warning banner to \"$warning_message\""
            log_file="$work_dir/$log_file"
            echo "$actual_value" > $log_file
            gconftool-2 -direct -config-source=xml:readwrite:$HOME/.gconf -t string -s /apps/gdm/simple-greeter/banner_message_text \"$warning_message\"
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            increment_secure "Warning banner is set to \"$warning_message\""
          fi
        fi
      else
        log_file="$restore_dir/$log_file"
        if [ -f "$log_file" ]; then
          restore_value=$( cat $log_file )
          if [ "$restore_value" != "$actual_value" ]; then
            verbose_message "Restoring: Warning banner to $previous_value"
            gconftool-2 -direct -config-source=xml:readwrite:$HOME/.gconf -t string -s /apps/gdm/simple-greeter/banner_message_text "$restore_value"
          fi
        fi
      fi
      actual_value=$( gconftool-2 --get /apps/gdm/simple-greeter/banner_message_enable )
      log_file="gnome_banner_status"
      if [ "$audit_mode" != 2 ]; then
        if [ "$actual_value" != "true" ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "Warning banner not found in $check_file"
            verbose_message "" fix
            verbose_message "gconftool-2 -direct -config-source=xml:readwrite:$HOME/.gconf -type bool -set /apps/gdm/simple-greeter/banner_message_enable true" fix
            verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            verbose_message "Setting:   Warning banner to \"$warning_message\""
            log_file="$work_dir/$log_file"
            echo "$actual_value" > $log_file
            gconftool-2 -direct -config-source=xml:readwrite:$HOME/.gconf -type bool -set /apps/gdm/simple-greeter/banner_message_enable true
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            increment_secure "Warning banner is set to \"$warning_message\""
          fi
        fi
      else
        log_file="$restore_dir/$log_file"
        if [ -f "$log_file" ]; then
          restore_value=$( cat $log_file )
          if [ "$restore_value" != "$actual_value" ]; then
            verbose_message "Restoring: Warning banner to $previous_value"
            gconftool-2 -direct -config-source=xml:readwrite:$HOME/.gconf -type bool -set /apps/gdm/simple-greeter/banner_message_enable "$restore_value"
          fi
        fi
      fi
    fi
  fi
}
