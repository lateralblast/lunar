# audit_syslog_server
#
# Linux and Solaris 11 (to be added):
#
# The rsyslog package is a third party package that provides many enhancements
# to syslog, such as multi-threading, TCP communication, message filtering and
# data base support.
#
# Refer to Section 4.1.1-6 Page(s) 71-76 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_postfix_daemon () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message="Rsyslog Daemon"
    if [ "$os_vendor" = "CentOS" ] and [ "$os_version" = "6" ]; then
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
}
