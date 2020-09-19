# audit_mount_fdi
#
# User mountable file systems on Linux.
#
# This can stop possible vectors of attack and escalated privileges.
#.

audit_mount_fdi () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "User Mountable Filesystems"
    check_dir="/usr/share/hal/fdi/95userpolicy"
    if [ -e "$check_dir" ]; then
      check_file="$check_dir/floppycdrom.fdi"
    else
      check_dir="/usr/share/hal/fdi/policy/20thirdparty"
      check_file="$check_dir/floppycdrom.fdi"
    fi
    if [ -d "$check_dir" ]; then
      if [ ! -f "$check_file" ]; then
        touch $check_file
        chmod 640 $check_file
        chown root:root $check_file
      fi
    fi
    if [ -f "$check_file" ]; then
      if [ "$audit_mode" != "2" ]; then
        fdi_check=$( grep -v "Default policies" $check_file | head -1 | wc -l )
        if [ "$fdi_check" = 1 ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "User mountable filesystems enabled"
            verbose_message "" fix
            verbose_message "echo '<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?> <!-- -*- SGML -*- --> >' > $temp_file" fix
            verbose_message "echo '<deviceinfo version=\"0.2\">' >> $temp_file" fix
            verbose_message "echo '  <!-- Default policies merged onto computer root object -->' >> $temp_file" fix
            verbose_message "echo '  <device>' >> $temp_file" fix
            verbose_message "echo '    <match key=\"info.udi\" string=\"/org/freedesktop/Hal/devices/computer\">' >> $temp_file" fix
            verbose_message "echo '      <merge key=\"storage.policy.default.mount_option.nodev\" type=\"bool\">true</merge>' >> $temp_file" fix
            verbose_message "echo '      <merge key=\"storage.policy.default.mount_option.nosuid\" type=\"bool\">true</merge>' >> $temp_file" fix
            verbose_message "echo '    </match>' >> $temp_file" fix
            verbose_message "echo '  </device>' >> $temp_file" fix
            verbose_message "echo '</deviceinfo>' >> $temp_file" fix
            verbose_message "cat $temp_file > $check_file" fix
            verbose_message "rm $temp_file" fix
            verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            verbose_message "Setting:   Disabling user mountable filesystems"
            backup_file $check_file
            echo '<?xml version="1.0" encoding="ISO-8859-1"?> <!-- -*- SGML -*- --> >' > $temp_file
            echo '<deviceinfo version="0.2">' >> $temp_file
            echo '  <!-- Default policies merged onto computer root object -->' >> $temp_file
            echo '  <device>' >> $temp_file
            echo '    <match key="info.udi" string="/org/freedesktop/Hal/devices/computer">' >> $temp_file
            echo '      <merge key="storage.policy.default.mount_option.nodev" type="bool">true</merge>' >> $temp_file
            echo '      <merge key="storage.policy.default.mount_option.nosuid" type="bool">true</merge>' >> $temp_file
            echo '    </match>' >> $temp_file
            echo '  </device>' >> $temp_file
            echo '</deviceinfo>' >> $temp_file
            cat $temp_file > $check_file
            rm $temp_file
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            increment_secure "User mountable filesystems disabled"
          fi
          if [ "$audit_mode" = 2 ]; then
            restore_file $check_file $restore_dir
          fi
        fi
      fi
    fi
    check_file_perms $check_file 0640 root root
  fi
}
