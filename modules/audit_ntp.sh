#!/bin/sh

# -> Needs fixing

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ntp
#
# Check NTP settings
#
# Refer to Section(s) 3.6           Page(s) 62-3    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.6           Page(s) 75-6    CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.6           Page(s) 65-6    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.1.1-2     Page(s) 98-101  CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 2.4.5.1       Page(s) 35-6    CIS Apple OS X 10.5 Benchmark v1.1.0
# Refer to Section(s) 2.2.1-3       Page(s) 26-31   CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 2.3.2.1-2     Page(s) 82-6    CIS Apple macOS 14 Sonoma Benchmark v1.0.0
# Refer to Section(s) 6.5           Page(s) 55-6    CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.9.2         Page(s) 16-7    CIS ESX Server 4 Benchmark v1.1.0
# Refer to Section(s) 2.2.1.1-2     Page(s) 90-2    CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.1.1-3     Page(s) 98-101  CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 2.3.1.1-3.3.3 Page(s) 306-26  CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_ntp () {
  print_module "audit_ntp"
  ntp_package="chrony"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "Darwin" ] || [ "${os_name}" = "VMkernel" ]; then
    verbose_message "Network Time Protocol" "check"
    if [ "${os_name}" = "SunOS" ]; then
      check_file_value "is" "/etc/inet/ntp.conf" "server" "space" "pool.ntp.org" "hash"
      if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
        check_sunos_service "svc:/network/ntp4:default" "enabled"
      fi
    fi
    if [ "${os_name}" = "Darwin" ]; then
      check_file_value   "is" "/private/etc/hostconfig" "TIMESYNC" "eq" "-YES-" "hash"
      check_launchctl_service "org.ntp.ntpd" "on"
      #check_file="/private/etc/ntp.conf"
      if [ "${long_os_version}" -ge 1009 ]; then
        check_file_value      "is" "/etc/ntp-restrict.conf" "restrict" "space" "lo interface ignore wildcard interface listen lo" "hash"
        check_osx_systemsetup "getusingnetworktime" "on"
        timeserver="${country_suffix}.pool.ntp.org"
        check_osx_systemsetup "getnetworktimeserver" "${timeserver}"
      fi
    fi
    if [ "${os_name}" = "VMkernel" ]; then
      check_linux_service "ntpd" "on"
      check_append_file   "/etc/ntp.conf" "restrict 127.0.0.1" "hash"
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_file="/etc/ntp.conf"
      log_file="ntp.log"
      do_chrony=0
      if [ "${os_vendor}" = "Red" ] || [ "${os_vendor}" = "CentOS" ] && [ "${os_version}" -ge 7 ]; then
        do_chrony=1
      fi
      if [ "${os_vendor}" = "Ubuntu" ] && [ "${os_version}" -ge 16 ]; then
        do_chrony=1
      fi
      if [ "${os_vendor}" = "Amazon" ]; then
        do_chrony=1
      fi
      if [ "${do_chrony}" -eq 1 ] && [ "${ntp_package}" = "chrony" ]; then
        old_package="systemd-timesyncd"
        check_linux_package     "uninstall"       "${old_package}"
        check_linux_service     "${old_package}"  "off"
        check_linux_package     "install"         "${ntp_package}"
        check_linux_service     "${ntp_package}"  "on"
        check_file_value        "is"      "/etc/sysconfig/chronyd" "OPTIONS" "eq" "\"-u chrony\"" "hash"
        for server_number in $( seq 0 3 ); do
          ntp_server="${server_number}.${country_suffix}.pool.ntp.org"
          check_file_value      "is" "/etc/chrony/chrony.conf" "pool" "${ntp_server} iburst" "space" "hash"
        done
      else
        if [ "${ntp_package}" = "systemd-timesyncd" ]; then
          old_package="chrony"
          check_linux_package   "uninstall"       "${old_package}"
          check_linux_service   "${old_package}"  "off"
          check_linux_package   "install"         "${ntp_package}"
          check_linux_service   "${ntp_package}"  "on"
          comf_file="/etc/systemd/timesyncd.conf"
          ntp_server="0.${country_suffix}.pool.ntp.org"
          check_file_value      "is" "${conf_file}" "NTP" "eq"              "${ntp_server}" "hash"
          ntp_server="1.${country_suffix}.pool.ntp.org"
          check_file_value      "is" "${conf_file}" "FallbackNTP" "eq"      "${ntp_server}" "hash"
        else
          check_linux_package   "install" "ntp"
          if [ -f "/usr/bin/systemctl" ]; then
            check_append_file   "/usr/lib/systemd/system/ntpd.service"      "restrict default kod nomodify nopeer notrap noquery"    "hash"
            check_append_file   "/usr/lib/systemd/system/ntpd.service"      "restrict -6 default kod nomodify nopeer notrap noquery" "hash"
            check_file_value    "is" "/usr/lib/systemd/system/ntpd.service" "OPTIONS"   "eq" "\"-u ntp:ntp -p /var/run/ntpd.pid\""   "hash"
            check_file_value    "is" "/usr/lib/systemd/system/ntpd.service" "ExecStart" "eq" "/usr/sbin/ntpd -u ntp:ntp \$OPTIONS"   "hash"
          else
            check_linux_service "ntp" "on"
          fi
          for server_number in $( seq 0 3 ); do
            ntp_server="${server_number}.${country_suffix}.pool.ntp.org"
            check_file_value "is" "/etc/ntp.conf" "server" "space" "${ntp_server}" "hash"
          done
        fi
      fi
    fi
  fi
}
