# audit_ntp
#
# Refer to Section(s) 3.6       Page(s) 62-3   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.6       Page(s) 75-6   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.6       Page(s) 65-6   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.1.1-2 Page(s) 98-101 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 2.4.5.1   Page(s) 35-6   CIS Apple OS X 10.5 Benchmark v1.1.0
# Refer to Section(s) 2.2.1-3   Page(s) 26-31  CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 6.5       Page(s) 55-6   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.9.2     Page(s) 16-7   CIS ESX Server 4 Benchmark v1.1.0
# Refer to Section(s) 2.2.1.1-2 Page(s) 90-2   CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.1.1-3 Page(s) 98-101 CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_ntp () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ] || [ "$os_name" = "VMkernel" ]; then
    verbose_message "Network Time Protocol"
    if [ "$os_name" = "SunOS" ]; then
      check_file="/etc/inet/ntp.conf"
      check_file_value is $check_file server space pool.ntp.org hash
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/network/ntp4:default"
        check_sunos_service $service_name enabled
      fi
    fi
    if [ "$os_name" = "Darwin" ]; then
      check_file="/private/etc/hostconfig"
      check_file_value is $check_file TIMESYNC eq -YES- hash
      check_launchctl_service org.ntp.ntpd on
      check_file="/private/etc/ntp.conf"
      if [ "$os_release" -ge 9 ]; then
        check_file="/etc/ntp-restrict.conf"
        check_file_value is $check_file restrict space "lo interface ignore wildcard interface listen lo" hash
        check_osx_systemsetup getusingnetworktime on
        timerserver="$country_suffix.pool.ntp.org"
        check_osx_systemsetup getnetworktimeserver $timerserver
      fi
    fi
    if [ "$os_name" = "VMkernel" ]; then
      service_name="ntpd"
      check_chkconfig_service $service_name on
      check_file="/etc/ntp.conf"
      check_append_file $check_file "restrict 127.0.0.1"
    fi
    if [ "$os_name" = "Linux" ]; then
      check_file="/etc/ntp.conf"
      log_file="ntp.log"
      do_chrony=0
      if [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "CentOS" ] && [ "$os_version" -ge 7 ]; then
        do_chrony=1
      fi
      if [ "$os_vendor" = "Ubuntu" ] && [ "$os_version" -ge 16 ]; then
        do_chrony=1
      fi
      if [ "$os_vendor" = "Amazon" ]; then
        do_chrony=1
      fi
      if [ "$do_chrony" -eq 1 ]; then
        check_linux_package install chrony
        check_file="/etc/sysconfig/chronyd"
        check_file_value is $check_file OPTIONS eq '"-u chrony"' hash
        check_file="/etc/chrony/chrony.conf"
        for server_number in $( seq 0 3 ); do
          ntp_server="$server_number.$country_suffix.pool.ntp.org"
          check_file_value is $check_file server space $ntp_server hash
        done
      else
        check_linux_package install ntp
        if [ -f "/usr/bin/systemctl" ]; then
          check_file="/usr/lib/systemd/system/ntpd.service"
          check_file_value is $check_file ExecStart eq "/usr/sbin/ntpd -u ntp:ntp $OPTIONS" hash
        else
          check_chkconfig_service $service_name 3 on
          check_chkconfig_service $service_name 5 on
        fi
        check_append_file $check_file "restrict default kod nomodify nopeer notrap noquery" hash
        check_append_file $check_file "restrict -6 default kod nomodify nopeer notrap noquery" hash
        check_file_value is $check_file OPTIONS eq '"-u ntp:ntp -p /var/run/ntpd.pid"' hash
        check_file="/etc/ntp.conf"
        for server_number in $( seq 0 3 ); do
          ntp_server="$server_number.$country_suffix.pool.ntp.org"
          check_file_value is $check_file server space $ntp_server hash
        done
      fi
    fi
  fi
}
