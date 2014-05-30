# audit_syslog_conf
#
# By default, Solaris systems do not capture logging information that is sent
# to the LOG_AUTH facility.
# A great deal of important security-related information is sent via the
# LOG_AUTH facility (e.g., successful and failed su attempts, failed login
# attempts, root login attempts, etc.).
#
# Refer to Section(s) 3.4 Page(s) 10 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 5.1.1 Page(s) 104-5 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.11.13 Page(s) 39-40 ESX Server 4 Benchmark v1.1.0
#.

audit_syslog_conf () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "VMkernel" ]; then
    funct_verbose_message "Syslog Configuration"
    if [ "$os_name" = "Linux" ]; then
      check_file="/etc/syslog.conf"
      funct_file_value $check_file "authpriv.*" tab "/var/log/secure" hash
      funct_file_value $check_file "auth.*" tab "/var/log/messages" hash
      funct_file_value $check_file "daemon.*" tab "/var/log/daemon.log" hash
      funct_file_value $check_file "syslog.*" tab "/var/log/syslog" hash
      funct_file_value $check_file "lpr,news,uucp,local0,local1,local2,local3,local4,local5,local6.*" tab "/var/log/unused.log" hash
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/rc.conf"
      funct_file_value $check_file syslogd_flags eq -s hash
    fi
    if [ "$os_name" = "VMkernel" ]; then
      total=`expr $total + 1`
      backup_file="$work_dir/syslogremotehost"
      current_value=`esxcli system syslog config get |grep Remote |awk '{print $3}'`
      if [ "$audit_mode" != "2" ]; then
        if [ "$current_value" = "<none>" ]; then
          if [ "$audit_more" = "0" ]; then
            if [ "$syslog_server" != "" ]; then
              echo "$current_value" > $backup_file
              esxcli system syslog config set --loghost="$syslog_server"
            fi
          fi
          if [ "$audit_mode" = "1" ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   Syslog remote host is not enabled [$insecure Warnings]"
            funct_verbose_message "" fix
            if [ "$syslog_server" != "" ]; then
              funct_verbose_message "esxcli system syslog config set --loghost=XXX.XXX.XXX.XXX" fix
            else
              funct_verbose_message "esxcli system syslog config set --loghost=$syslog_server" fix
            fi
            funct_verbose_message "" fix
          fi
        else
          if [ "$audit_mode" = "1" ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Syslog remote host is enabled [$secure Passes]"
          fi
        fi
      else
        if [ -f "$backup_file" ]; then
          previous_value=`cat $backup_file`
          if [ "$previous_value" != "$current_value" ]; then
            esxcli system syslog config set --loghost="$previous_value"
          fi
        fi
      fi
    fi
  fi
}
