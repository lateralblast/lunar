# audit_syslog_server
#
# Linux and Solaris 11 (to be added):
#
# The rsyslog package is a third party package that provides many enhancements
# to syslog, such as multi-threading, TCP communication, message filtering and
# data base support.
#
# FreeBSD
#
# Capture ftpd and inetd information
# FreeBSD 5.X has this feature enabled by default. Although the log file is
# called debug.log.
#
# Refer to Section(s) 4.1.1-8 Page(s) 71-76 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 5.2.1-8 Page(s) 108-113 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 5.1.1-8 Page(s) 94-9 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 8.2.1-8 Page(s) 106-111 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 5.1 Page(s) 18 CIS FreeBSD Benchmark v1.0.5
#.

audit_syslog_server () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    if [ "$os_name" = "FreeBSD" ]; then
      if [ "$os_version" < 5 ]
        funct_verbose_message="Syslog Daemon"
        check_file="/etc/syslog.conf"
        funct_file_value $check_file "daemon.debiug" tab "/var/log/daemon.log" hash
        check_file="/var/log/daemon.log"
        funct_file_exists $check_file yes
        funct_file_perms $check_file 600 root wheel
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      if [ "$install_rsyslog" = "yes" ]; then
        funct_verbose_message="Rsyslog Daemon"
        if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "SuSE" ]; then
          if [ "$os_version" > 4 ]; then
            service_name="syslog"
            funct_chkconfig_service $service_name 3 off
            funct_chkconfig_service $service_name 5 off
            service_name="rsyslog"
            check_file="/etc/rsyslog.conf"
            funct_file_value $check_file "auth,user.*" tab "/var/log/messages" hash
            funct_file_value $check_file "kern.*" tab "/var/log/kern.log" hash
            funct_file_value $check_file "daemon.*" tab "/var/log/daemon.log" hash
            funct_file_value $check_file "syslog.*" tab "/var/log/syslog" hash
            funct_file_value $check_file "lpr,news,uucp,local0,local1,local2,local3,local4,local5,local6.*" tab "/var/log/unused.log" hash
            funct_file_value $check_file "" tab "" hash
            funct_linux_package install $service_name
            funct_chkconfig_service $service_name 3 on
            funct_chkconfig_service $service_name 5 on
            funct_file_perms $check_file 0600 root root
            if [ "$audit_mode" != 2 ]; then
               echo "Checking:  Rsyslog is sending message to a remote server"
              remote_check=`cat $check_file |grep -v '#' |grep '*.* @@' |grep -v localhost |grep '[A-z]' |wc -l`
              if [ "$remote_check" != "1" ]; then
                if [ "$audit_mode" = 1 ] || [ "$audit_mode" = 0 ]; then
                  total=`expr $total + 1`
                  score=`expr $score - 1`
                  echo "Warning:   Rsyslog is not sending messages to a remote server [$score]"
                  funct_verbose_message "" fix
                  funct_verbose_message "Add a server entry to $check_file, eg:" fix
                  funct_verbose_message "*.* @@loghost.example.com" fix
                  funct_verbose_message "" fix
                fi
              else
                total=`expr $total + 1`
                score=`expr $score + 1`
                echo "Secure:    Rsyslog is sending messages to a remote server [$score]"
              fi
            fi
          fi
        fi
      fi
    fi
  fi
}
