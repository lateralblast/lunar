# audit_xlogin
#
# Refer to Section(s) 7.7   Page(s) 26 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.4 Page(s) 38 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.1   Page(s) 15 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 2.1.3 Page(s) 19 CIS Solaris 10 Benchmark v5.1.0
#.

audit_xlogin () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "X Windows"
    if [ "$os_name" = "AIX" ]; then
      verbose_message "CDE Startup"
      check_itab dt off
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
       verbose_message "XDMCP Listening"
      fi
      if [ "$os_version" = "10" ]; then
        service_name="svc:/application/graphical-login/cde-login"
        check_sunos_service $service_name disabled
        service_name="svc:/application/gdm2-login"
        check_sunos_service $service_name disabled
      fi
      if [ "$os_version" = "11" ]; then
        service_name="svc:/application/graphical_login/gdm:default"
        check_sunos_service $service_name disabled
      fi
      if [ "$os_version" = "10" ]; then
        service_name="dtlogin"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/ttys"
      check_string="nodaemon"
      ttys_test=$( grep $check_string $check_file | awk '{print $5}' )
      if [ "$ttys_test" != "on" ]; then
        if [ "$audit_mode" != 2 ]; then
          if [ "$ansible" = 1 ]; then
            echo ""
            echo "- name: Checking X Wrapper is disabled"
            echo "  lineinfile:"
            echo "    path: $check_file"
            echo "    regexp: '/xdm -nodaemon/s/off/on/'"
            echo "  when: ansible_facts['ansible_system'] == '$os_name'"
          fi
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "X wrapper is not disabled"
          fi
          if [ "$audit_mode" = 2 ]; then
            verbose_message "Setting:   X wrapper to disabled"
            backup_file $check_file
            tmp_file="/tmp/ttys_$check_string"
            sed -e '/xdm -nodaemon/s/off/on/' $check_file > $tmp_file
            cat $tmp_file > $check_file
          fi
        else
          restore_file $check_file $restore_dir
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          increment_secure "X wrapper is disabled"
        fi
      fi
    fi
    if [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/X11/xdm/Xresources"
      if [ -f "$check_file" ]; then
        verbose_message "X Security Message"
        if [ "$audit_mode" != 2 ]; then
          greet_check=$( grep -c 'private system' $check_file )
          if [ "$greet_check" != 1 ]; then
           verbose_message "File $check_file for security message"
           greet_mesg="This is a private system --- Authorized use only!"
           if [ "$audit_mode" = 1 ]; then
             increment_insecure "File $check_file does not have a security message"
             verbose_message "" fix
             verbose_message "cat $check_file |awk '/xlogin\*greeting:/ { print GreetValue; next }; { print }' GreetValue=\"$greet_mesg\" > $temp_file" fix
             verbose_message "cat $temp_file > $check_file" fix
             verbose_message "rm $temp_file" fix
             verbose_message "" fix
           else
             verbose_message "Setting:   Security message in $check_file"
             backup_file $check_file
             cat $check_file |awk '/xlogin\*greeting:/ { print GreetValue; next }; { print }' GreetValue="$greet_mesg" > $temp_file
             cat $temp_file > $check_file
             rm $temp_file
             fi
          else
            increment_secure "File $check_file has security message"
          fi
        else
          restore_file $check_file $restore_dir
        fi
      fi
      check_file="/etc/X11/xdm/kdmrc"
      if [ -f "$check_file" ]; then
        verbose_message "X Security Message"
        if [ "$audit_mode" != 2 ]; then
          greet_check=$( grep -c 'private system' $check_file )
          greet_mesg="This is a private system --- Authorized USE only!"
          if [ "$greet_check" != 1 ]; then
            verbose_message "File $check_file for security message"
             if [ "$audit_mode" = 1 ]; then
               increment_insecure "File $check_file does not have a security message"
               verbose_message "" fix
               verbose_message "cat $check_file |awk '/GreetString=/ { print \"GreetString=\" GreetString; next }; { print }' GreetString=\"$greet_mesg\" > $temp_file" fix
               verbose_message "cat $temp_file > $check_file" fix
               verbose_message "rm $temp_file" fix
               verbose_message "" fix
             else
               verbose_message "Setting:   Security message in $check_file"
               backup_file $check_file
               cat $check_file |awk '/GreetString=/ { print "GreetString=" GreetString; next }; { print }' GreetString="$greet_mesg" > $temp_file
               cat $temp_file > $check_file
               rm $temp_file
             fi
          else
            increment_secure "File $check_file has security message"
          fi
        else
          restore_file $check_file $restore_dir
        fi
      fi
      check_file="/etc/X11/xdm/Xservers"
      if [ -f "$check_file" ]; then
        verbose_message "X Listening"
        if [ "$audit_mode" != 2 ]; then
          greet_check=$( grep -c 'nolisten tcp' $check_file )
          if [ "$greet_check" != 1 ]; then
            verbose_message "For X11 nolisten directive in $check_file"
            if [ "$audit_mode" = 1 ]; then
              increment_insecure "X11 nolisten directive not found in $check_file"
              verbose_message "" fix
              verbose_message "cat $check_file |awk '( $1 !~ /^#/ && $3 == \"/usr/X11R6/bin/X\" ) { $3 = $3 \" -nolisten tcp\" }; { print }' > $temp_file" fix
              verbose_message "cat $check_file |awk '( $1 !~ /^#/ && $3 == \"/usr/bin/X\" ) { $3 = $3 \" -nolisten tcp\" }; { print }' > $temp_file" fix
              verbose_message "cat $temp_file > $check_file" fix
              verbose_message "rm $temp_file" fix
              verbose_message "" fix
            else
              verbose_message "Setting:   Security message in $check_file"
              backup_file $check_file
              cat $check_file |awk '( $1 !~ /^#/ && $3 == "/usr/X11R6/bin/X" ) { $3 = $3 " -nolisten tcp" }; { print }' > $temp_file
              cat $check_file |awk '( $1 !~ /^#/ && $3 == "/usr/bin/X" ) { $3 = $3 " -nolisten tcp" }; { print }' > $temp_file
              cat $temp_file > $check_file
              rm $temp_file
            fi
          else
            increment_secure "X11 nolisten directive found in $check_file"
          fi
        else
          restore_file $check_file $restore_dir
        fi
      fi
    fi
  fi
}
