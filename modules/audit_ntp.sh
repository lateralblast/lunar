# audit_ntp
#
# Network Time Protocol (NTP) is a networking protocol for clock synchronization
# between computer systems.
# Most security mechanisms require network time to be synchronized.
#.

audit_ntp () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Network Time Protocol"
    check_file="/etc/inet/ntp.conf"
    funct_file_value $check_file server space pool.ntp.org hash
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      service_name="svc:/network/ntp4:default"
      funct_service $service_name enabled
    fi
  fi
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Network Time Protocol"
    check_file="/private/etc/hostconfig"
    funct_file_value $check_file TIMESYNC eq -YES- hash
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Network Time Protocol"
    check_file="/etc/ntp.conf"
    total=`expr $total + 1`
    log_file="ntp.log"
    audit_linux_package check ntp
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  NTP is enabled"
    fi
    if [ "$package_name" != "ntp" ]; then
      if [ "$audit_mode" = 1 ]; then
        score=`expr $score - 1`
        echo "Warning:   NTP not enabled [$score]"
      fi
      if [ "$audit_mode" = 0 ]; then
        echo "Setting:   NTP to enabled"
        log_file="$work_dir/$log_file"
        echo "Installed ntp" >> $log_file
        audit_linux_package install ntp
      fi
    else
      if [ "$audit_mode" = 1 ]; then
        score=`expr $score + 1`
        echo "Secure:    NTP enabled [$score]"
      fi
      if [ "$audit_mode" = 2 ]; then
        restore_file="$restore_dir/$log_file"
        audit_linux_package restore ntp $restore_file
      fi
    fi
    service_name="ntp"
    funct_chkconfig_service $service_name 3 on
    funct_chkconfig_service $service_name 5 on
    funct_append_file $check_file "restrict default kod nomodify nopeer notrap noquery" hash
    funct_append_file $check_file "restrict -6 default kod nomodify nopeer notrap noquery" hash
    funct_file_value $check_file OPTIONS eq "-u ntp:ntp -p /var/run/ntpd.pid" hash
  fi
}
