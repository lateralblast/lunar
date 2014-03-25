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
# Refer to Section(s) 3.1 Page(s) 9 CIS FreeBSD Benchmark v1.0.5
#.

audit_serial_login () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "FreeBSD" ]; then
    funct_verbose_message "Login on Serial Ports"
    if [ "$os_name" = "SunOS" ]; then
      total=`expr $total + 1`
      if [ "$os_version" = "10" ]; then
        serial_test=`pmadm -L |egrep "ttya|ttyb" |cut -f4 -d ":" |grep "ux" |wc -l`
        log_file="$work_dir/pmadm.log"
        if [ `expr "$serial_test" : "2"` = 1 ]; then
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score + 1`
            echo "Secure:    Serial port logins disabled [$score]"
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score - 1`
            echo "Warning:   Serial port logins not disabled [$score]"
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
            score=`expr $score - 1`
            echo "Warning:   Serial port logins not disabled [$score]"
          fi
          if [ "$audit_mode" = 2 ]; then
            echo "Setting:   Serial port logins to disabled"
            backup_file $check_file
            tmp_file="/tmp/ttys_$check_string"
            awk '($4 == "dialup") { $5 = "off" } { print }' $check_file > $tmp_file
            cat $tmp_file > $check_file
          fi
        else
          funct_restore_file $check_file $restore_dir
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score + 1`
          echo "Secure:    Serial port logins disabled [$score]"
        fi
      fi
    fi
  fi
}
