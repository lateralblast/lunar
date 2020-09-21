# audit_syslog_server
#
# Refer to Section(s) 4.1.1-8   Page(s) 71-76   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 5.2.1-8   Page(s) 108-113 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 5.1.1-8   Page(s) 94-9    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 4.2.1.1-5 Page(s) 192-198 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 8.2.1-8   Page(s) 106-111 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 5.1       Page(s) 18      CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 4.2.1.1-5 Page(s) 176-82  CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 4.2.1.1-5 Page(s) 187-93  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_syslog_server () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    verbose_message="Checking:  Syslog Daemon"
    if [ "$os_name" = "FreeBSD" ]; then
      if [ "$os_version" -lt 5 ]; then
        check_file="/etc/syslog.conf"
        check_file_value is $check_file "daemon.debug" tab "/var/log/daemon.log" hash
        check_file="/var/log/daemon.log"
        check_file_exists $check_file yes
        funct_file_perms $check_file 600 root wheel
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      if [ "$install_rsyslog" = "yes" ]; then
        if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "SuSE" ] || [ "$os_vendor" = "Amazon" ]; then
          if [ "$os_version" -lt 4 ]; then
            service_name="syslog"
            check_chkconfig_service $service_name 3 off
            check_chkconfig_service $service_name 5 off
            service_name="rsyslog"
            check_file="/etc/rsyslog.conf"
            check_file_value is $check_file "auth,user.*" tab "/var/log/messages" hash
            check_file_value is $check_file "kern.*" tab "/var/log/kern.log" hash
            check_file_value is $check_file "daemon.*" tab "/var/log/daemon.log" hash
            check_file_value is $check_file "syslog.*" tab "/var/log/syslog" hash
            check_file_value is $check_file "lpr,news,uucp,local0,local1,local2,local3,local4,local5,local6.*" tab "/var/log/unused.log" hash
            # check_file_value is $check_file "" tab "" hash
            check_linux_package install $service_name
            check_systemctl_service enable $service_name
            check_chkconfig_service $service_name 3 on
            check_chkconfig_service $service_name 5 on
            funct_file_perms $check_file 0600 root root
            if [ "$audit_mode" != 2 ]; then
              remote_check=$( grep -v '#' $check_file | grep '*.* @@' | grep -v localhost | grep -c '[A-z]' )
              if [ "$remote_check" != "1" ]; then
                if [ "$audit_mode" = 1 ] || [ "$audit_mode" = 0 ]; then
                  increment_insecure "Rsyslog is not sending messages to a remote server"
                  verbose_message "" fix
                  verbose_message "Add a server entry to $check_file, eg:" fix
                  verbose_message "*.* @@loghost.example.com" fix
                  verbose_message "" fix
                fi
              else
                increment_secure "Rsyslog is sending messages to a remote server"
              fi
            fi
          fi
        fi
      fi
    fi
  fi
}
