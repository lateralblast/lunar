# audit_xlogin
#
# The CDE login service provides the capability of logging into the system
# using  Xwindows. XDMCP provides the capability of doing this remotely.
# If XDMCP remote session access to a machine is not required at all,
# but graphical login access for the console is required, then
# leave the service in local-only mode.
#
# Most modern servers are rack mount so you will not be able to log
# into the console using X Windows anyway.
# Disabling these does not prevent support staff from running
# X Windows applications remotely over SSH.
#
# Running these commands will kill  any active graphical sessions
# on the console or using XDMCP. It will not kill any X Windows
# applications running via SSH.
#
# Refer to Section(s) 7.7 Page(s) 26 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.4 Page(s) 38 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.1 Page(s) 15 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 2.1.3 Page(s) 19 CIS Solaris 10 v5.1.0
#.

audit_xlogin () {
  if [ "$os_name" = "AIX" ]; then
    funct_verbose_message "CDE Startup"
    funct_itab_check dt off
  fi
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "XDMCP Listening"
    fi
    if [ "$os_version" = "10" ]; then
      service_name="svc:/application/graphical-login/cde-login"
      funct_service $service_name disabled
      service_name="svc:/application/gdm2-login"
      funct_service $service_name disabled
    fi
    if [ "$os_version" = "11" ]; then
      service_name="svc:/application/graphical_login/gdm:default"
      funct_service $service_name disabled
    fi
    if [ "$os_version" = "10" ]; then
      service_name="dtlogin"
      funct_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "FreeBSD" ]; then
    check_file="/etc/ttys"
    check_string="nodaemon"
    ttys_test=`cat $check_file |grep $check_string |awk '{print $5}'`
    if [ "$ttys_test" != "on" ]; then
      if [ "$audit_mode" != 2 ]; then
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score - 1`
          echo "Warning:   X wrapper is not disabled [$score]"
        fi
        if [ "$audit_mode" = 2 ]; then
          echo "Setting:   X wrapper to disabled"
          backup_file $check_file
          tmp_file="/tmp/ttys_$check_string"
          sed -e '/xdm -nodaemon/s/off/on/' $check_file > $tmp_file
          cat $tmp_file > $check_file
        fi
      else
        funct_restore_file $check_file $restore_dir
      fi
    else
      if [ "$audit_mode" = 1 ]; then
        score=`expr $score + 1`
        echo "Secure:    X wrapper is disabled [$score]"
      fi
    fi
  fi
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    check_file="/etc/X11/xdm/Xresources"
    if [ -f "$check_file" ]; then
      funct_verbose_message "X Security Message"
      total=`expr $total + 1`
     if [ "$audit_mode" != 2 ]; then
       greet_check=`cat $check_file |grep 'private system' |wc -l`
       if [ "$greet_check" != 1 ]; then
         echo "Checking:  Checking $check_file for security message"
         greet_mesg="This is a private system --- Authorized use only!"
         if [ "$audit_mode" = 1 ]; then
           score=`expr $score - 1`
           echo "Warning:   File $check_file does not have a security message [$score]"
           funct_verbose_message "" fix
           funct_verbose_message "cat $check_file |awk '/xlogin\*greeting:/ { print GreetValue; next }; { print }' GreetValue=\"$greet_mesg\" > $temp_file" fix
           funct_verbose_message "cat $temp_file > $check_file" fix
           funct_verbose_message "rm $temp_file" fix
           funct_verbose_message "" fix
         else
           echo "Setting:   Security message in $check_file"
           funct_backup_file $check_file
           cat $check_file |awk '/xlogin\*greeting:/ { print GreetValue; next }; { print }' GreetValue="$greet_mesg" > $temp_file
           cat $temp_file > $check_file
           rm $temp_file
           fi
        else
          score=`expr $score + 1`
          echo "Secure:    File $check_file has security message [$score]"
        fi
      else
        funct_restore_file $check_file $restore_dir
      fi
    fi
    check_file="/etc/X11/xdm/kdmrc"
    if [ -f "$check_file" ]; then
      funct_verbose_message "X Security Message"
      total=`expr $total + 1`
      if [ "$audit_mode" != 2 ]; then
        greet_check= `cat $check_file |grep 'private system' |wc -l`
        greet_mesg="This is a private system --- Authorized USE only!"
        if [ "$greet_check" != 1 ]; then
           echo "Checking:  File $check_file for security message"
           if [ "$audit_mode" = 1 ]; then
             score=`expr $score - 1`
             echo "Warning:   File $check_file does not have a security message [$score]"
             funct_verbose_message "" fix
             funct_verbose_message "cat $check_file |awk '/GreetString=/ { print \"GreetString=\" GreetString; next }; { print }' GreetString=\"$greet_mesg\" > $temp_file" fix
             funct_verbose_message "cat $temp_file > $check_file" fix
             funct_verbose_message "rm $temp_file" fix
             funct_verbose_message "" fix
           else
             echo "Setting:   Security message in $check_file"
             funct_backup_file $check_file
             cat $check_file |awk '/GreetString=/ { print "GreetString=" GreetString; next }; { print }' GreetString="$greet_mesg" > $temp_file
             cat $temp_file > $check_file
             rm $temp_file
           fi
        else
          score=`expr $score + 1`
          echo "Secure:    File $check_file has security message [$score]"
        fi
      else
        funct_restore_file $check_file $restore_dir
      fi
    fi
    check_file="/etc/X11/xdm/Xservers"
    if [ -f "$check_file" ]; then
      funct_verbose_message "X Listening"
      total=`expr $total + 1`
      if [ "$audit_mode" != 2 ]; then
        greet_check=`cat $check_file |grep 'nolisten tcp' |wc -l`
        if [ "$greet_check" != 1 ]; then
           echo "Checking:  For X11 nolisten directive in $check_file"
           if [ "$audit_mode" = 1 ]; then
             score=`expr $score - 1`
             echo "Warning:   X11 nolisten directive not found in $check_file [$score]"
             funct_verbose_message "" fix
             funct_verbose_message "cat $check_file |awk '( $1 !~ /^#/ && $3 == \"/usr/X11R6/bin/X\" ) { $3 = $3 \" -nolisten tcp\" }; { print }' > $temp_file" fix
             funct_verbose_message "cat $check_file |awk '( $1 !~ /^#/ && $3 == \"/usr/bin/X\" ) { $3 = $3 \" -nolisten tcp\" }; { print }' > $temp_file" fix
             funct_verbose_message "cat $temp_file > $check_file" fix
             funct_verbose_message "rm $temp_file" fix
             funct_verbose_message "" fix
           else
             echo "Setting:   Security message in $check_file"
             funct_backup_file $check_file
             cat $check_file |awk '( $1 !~ /^#/ && $3 == "/usr/X11R6/bin/X" ) { $3 = $3 " -nolisten tcp" }; { print }' > $temp_file
             cat $check_file |awk '( $1 !~ /^#/ && $3 == "/usr/bin/X" ) { $3 = $3 " -nolisten tcp" }; { print }' > $temp_file
             cat $temp_file > $check_file
             rm $temp_file
           fi
        else
          score=`expr $score + 1`
          echo "Secure:    X11 nolisten directive found in $check_file [$score]"
        fi
      else
        funct_restore_file $check_file $restore_dir
      fi
    fi
  fi
}
