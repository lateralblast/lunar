# audit_serial_login
#
# The pmadm command provides service administration for the lower level of the
# Service Access Facility hierarchy and can be used to disable the ability to
# login on a particular port.
# By disabling the login: prompt on the system serial devices, unauthorized
# users are limited in their ability to gain access by attaching modems,
# terminals, and other remote access devices to these ports. Note that this
# action may safely be performed even if console access to the system is
# provided via the serial ports, because the login: prompt on the console
# device is provided through a different mechanism.
#
# Refer to Section(s) 3.1    Page(s) 9     CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.12.1 Page(s) 206-7 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 6.1    Page(s) 46-7  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.2    Page(s) 87-8  CIS Solaris 10 Benchmark v5.1.0
#.

audit_serial_login () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "Login on Serial Ports"
    if [ "$os_name" = "AIX" ]; then
      tty_list=`lsitab –a |grep "on:/usr/sbin/getty" |awk '{print $2}'`
      if [ `expr "$tty_list" : "[A-z]"` != 1 ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          secure=`expr $secure + 1`
          echo "Secure:    Serial port logins disabled [$secure Passes]"
        fi
        if [ "$audit_mode" = 2 ]; then
          tty_list=`lsitab –a |grep "/usr/sbin/getty" |awk '{print $2}'`
          for tty_name in `echo "$tty_list"`; do
            log_file="$restore_dir/$tty_name"
            if [ -f "$log_file" ]; then
              previous_value=`cat $log_file`
              echo "Restoring: TTY $tty_name to $previous_value"
              chitab "$previous_value $tty_name"
            fi
          done
        fi
      else
        for tty_name in `echo "$tty_list"`; do
          if [ "$audit_mode" != 2 ]; then
            log_file="$work_dir/$tty_name"
            actual_value=`lsitab -a |grep "on:/usr/sbin/getty" |grep $tty_name`
            new_value=`echo "$actual_value" |sed 's/on/off/g'`
            if [ "$audit_mode" = 1 ]; then
              total=`expr $total + 1`
              insecure=`expr $insecure + 1`
              echo "Warning:   Serial port logins not disabled on $tty_name [$insecure Warnings]"
              funct_verbose_message "" fix
              funct_verbose_message "chitab \"$new_value\"" fix
              funct_verbose_message "" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              echo "$actual_value" > $log_file
              chitab "$new_value $tty_name"
            fi
          else
            log_file="$restore_dir/$tty_name"
            if [ -f "$log_file" ]; then
              previous_value=`cat $log_file`
              echo "Restoring: TTY $tty_name to $previous_value"
              chitab "$previous_value $tty_name"
            fi
          fi
        done
      fi
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" != "11" ]; then
        serial_test=`pmadm -L |egrep "ttya|ttyb" |cut -f4 -d ":" |grep "ux" |wc -l`
        log_file="$work_dir/pmadm.log"
        if [ `expr "$serial_test" : "2"` = 1 ]; then
          if [ "$audit_mode" = 1 ]; then
            total=`expr $total + 1`
            secure=`expr $secure + 1`
            echo "Secure:    Serial port logins disabled [$secure Passes]"
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            total=`expr $total + 1`
            insecure=`expr $insecure + 1`
            echo "Warning:   Serial port logins not disabled [$insecure Warnings]"
            funct_verbose_message "" fix
            funct_verbose_message "pmadm -d -p zsmon -s ttya" fix
            funct_verbose_message "pmadm -d -p zsmon -s ttyb" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   Serial port logins to disabled"
            echo "ttya,ttyb" >> $log_file
            pmadm -d -p zsmon -s ttya
            pmadm -d -p zsmon -s ttyb
          fi
        fi
        if [ "$audit_mode" = 2 ]; then
          restore_file="$restore_dir/pmadm.log"
          if [ -f "$restore_file" ]; then
            echo "Restoring: Serial port logins to enabled"
            pmadm -e -p zsmon -s ttya
            pmadm -e -p zsmon -s ttyb
          fi
        fi
      fi
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/ttys"
      check_string="dialup"
      ttys_test=`cat $check_file |grep $check_string |awk '{print $5}'`
      if [ "$ttys_test" != "off" ]; then
        if [ "$audit_mode" != 2 ]; then
          if [ "$audit_mode" = 1 ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   Serial port logins not disabled [$insecure Warnings]"
          fi
          if [ "$audit_mode" = 2 ]; then
            echo "Setting:   Serial port logins to disabled"
            funct_backup_file $check_file
            tmp_file="/tmp/ttys_$check_string"
            awk '($4 == "dialup") { $5 = "off" } { print }' $check_file > $tmp_file
            cat $tmp_file > $check_file
          fi
        else
          funct_restore_file $check_file $restore_dir
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          secure=`expr $secure + 1`
          echo "Secure:    Serial port logins disabled [$secure Passes]"
        fi
      fi
    fi
  fi
}
