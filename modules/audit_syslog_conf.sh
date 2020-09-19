# audit_syslog_conf
#
# Refer to http://kb.vmware.com/kb/1033696
# Refer to http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.security.doc/GUID-9F67DB52-F469-451F-B6C8-DAE8D95976E7.html
# Refer to Section(s) 3.4     Page(s) 10    CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 5.1.1   Page(s) 104-5 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.11.13 Page(s) 39-40 CIS ESX Server 4 Benchmark v1.1.0
#.

audit_syslog_conf () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "VMkernel" ]; then
    verbose_message "Syslog Configuration"
    if [ "$os_name" = "Linux" ]; then
      check_file="/etc/syslog.conf"
      check_file_value is $check_file "authpriv.*" tab "/var/log/secure" hash
      check_file_value is $check_file "auth.*" tab "/var/log/messages" hash
      check_file_value is $check_file "daemon.*" tab "/var/log/daemon.log" hash
      check_file_value is $check_file "syslog.*" tab "/var/log/syslog" hash
      check_file_value is $check_file "lpr,news,uucp,local0,local1,local2,local3,local4,local5,local6.*" tab "/var/log/unused.log" hash
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/rc.conf"
      check_file_value is $check_file syslogd_flags eq -s hash
    fi
    if [ "$os_name" = "VMkernel" ]; then
      log_file="sysloglogdir"
      backup_file="$work_dir/$log_file"
      current_value=$( esxcli system syslog config get | grep 'Local Log Output:' | awk '{print $4}' )
      if [ "$audit_mode" != "2" ]; then
        if [ "$current_value" = "/scratch/log" ]; then
          if [ "$audit_mode" = "0" ]; then
            if [ "$syslog_logdir" != "" ]; then
              echo "$current_value" > $backup_file
              verbose_message "Setting:   Syslog log directory to a persistent datastore"
              esxcli system syslog config set --logdir="$syslog_logdir"
            fi
          fi
          if [ "$audit_mode" = "1" ]; then
            increment_insecure "Syslog log directory is not persistent"
            if [ "$syslog_logdir" != "" ]; then
              verbose_message "" fix
              verbose_message "esxcli system syslog config set --logdir=$syslog_logdir" fix
            fi
          fi
        else
          if [ "$audit_mode" = "1" ]; then
            increment_secure "Syslog log directory is on a persistent datastore"
          fi
        fi
      else
        restore_file="$restore_dir/$log_file"
        if [ -f "$restore_file" ]; then
          previous_value=$( cat $restore_file )
          if [ "$previous_value" != "$current_value" ]; then
            verbose_message "Restoring: Syslog log directory to $previous_value"
            esxcli system syslog config set --logdir="$previous_value"
          fi
        fi
      fi
      log_file="syslogremotehost"
      backup_file="$work_dir/$log_file"
      current_value=$( esxcli system syslog config get | grep Remote | awk '{print $3}' )
      if [ "$audit_mode" != "2" ]; then
        if [ "$current_value" = "<none>" ]; then
          if [ "$audit_mode" = "0" ]; then
            if [ "$syslog_server" != "" ]; then
              echo "$current_value" > $backup_file
              esxcli system syslog config set --loghost="$syslog_server"
            fi
          fi
          if [ "$audit_mode" = "1" ]; then
            verbose_message "" fix
            increment_insecure "Syslog remote host is not enabled"
            if [ "$syslog_server" = "" ]; then
              verbose_message "" fix
              verbose_message "esxcli system syslog config set --loghost=XXX.XXX.XXX.XXX" fix
            else
              verbose_message "" fix
              verbose_message "esxcli system syslog config set --loghost=$syslog_server" fix
            fi
          fi
        else
          if [ "$audit_mode" = "1" ]; then
            increment_secure "Syslog remote host is enabled"
          fi
        fi
      else
        restore_file="$restore_dir/$log_file"
        if [ -f "$restore_file" ]; then
          previous_value=$( cat $restore_file )
          if [ "$previous_value" != "$current_value" ]; then
            verbose_message "Restoring: Syslog loghost to $previous_value"
            esxcli system syslog config set --loghost="$previous_value"
          fi
        fi
      fi
    fi
  fi
}
