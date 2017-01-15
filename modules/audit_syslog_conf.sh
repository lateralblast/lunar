# audit_syslog_conf
#
# By default, Solaris systems do not capture logging information that is sent
# to the LOG_AUTH facility.
# A great deal of important security-related information is sent via the
# LOG_AUTH facility (e.g., successful and failed su attempts, failed login
# attempts, root login attempts, etc.).
#
# ESXi can be configured to store log files on an in-memory file system.
# This occurs when the host's "/scratch" directory is linked to "/tmp/scratch".
# When this is done only a single day's worth of logs are stored at any time,
# in addition log files will be reinitialized upon each reboot.
# This presents a security risk as user activity logged on the host is only
# stored temporarily and will not persistent across reboots.
# This can also complicate auditing and make it harder to monitor events and
# diagnose issues.
# ESXi host logging should always be configured to a persistent datastore.
#
# Refer to:
#
# http://kb.vmware.com/kb/1033696
# http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.security.doc/GUID-9F67DB52-F469-451F-B6C8-DAE8D95976E7.html
#
# Refer to Section(s) 3.4     Page(s) 10    CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 5.1.1   Page(s) 104-5 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.11.13 Page(s) 39-40 CIS ESX Server 4 Benchmark v1.1.0
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
      log_file="sysloglogdir"
      backup_file="$work_dir/$log_file"
      current_value=`esxcli system syslog config get |grep 'Local Log Output:' |awk '{print $4}'`
      if [ "$audit_mode" != "2" ]; then
        if [ "$current_value" = "/scratch/log" ]; then
          if [ "$audit_more" = "0" ]; then
            if [ "$syslog_logdir" != "" ]; then
              echo "$current_value" > $backup_file
              echo "Setting:   Syslog log directory to a persistent datastore"
              esxcli system syslog config set --logdir="$syslog_logdir"
            fi
          fi
          if [ "$audit_mode" = "1" ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   Syslog log directory is not persistent [$insecure Warnings]"
            if [ "$syslog_logdir" != "" ]; then
              funct_verbose_message "" fix
              funct_verbose_message "esxcli system syslog config set --logdir=$syslog_logdir" fix
            fi
          fi
        else
          if [ "$audit_mode" = "1" ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Syslog log directory is on a persistent datastore [$secure Passes]"
          fi
        fi
      else
        restore_file="$restore_dir/$log_file"
        if [ -f "$restore_file" ]; then
          previous_value=`cat $restore_file`
          if [ "$previous_value" != "$current_value" ]; then
            echo "Restoring: Syslog log directory to $previous_value"
            esxcli system syslog config set --logdir="$previous_value"
          fi
        fi
      fi
      total=`expr $total + 1`
      log_file="syslogremotehost"
      backup_file="$work_dir/$log_file"
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
            funct_verbose_message "" fix
            echo "Warning:   Syslog remote host is not enabled [$insecure Warnings]"
            if [ "$syslog_server" = "" ]; then
              funct_verbose_message "" fix
              funct_verbose_message "esxcli system syslog config set --loghost=XXX.XXX.XXX.XXX" fix
            else
              funct_verbose_message "" fix
              funct_verbose_message "esxcli system syslog config set --loghost=$syslog_server" fix
            fi
          fi
        else
          if [ "$audit_mode" = "1" ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Syslog remote host is enabled [$secure Passes]"
          fi
        fi
      else
        restore_file="$restore_dir/$log_file"
        if [ -f "$restore_file" ]; then
          previous_value=`cat $restore_file`
          if [ "$previous_value" != "$current_value" ]; then
            echo "Restoring: Syslog loghost to $previous_value"
            esxcli system syslog config set --loghost="$previous_value"
          fi
        fi
      fi
    fi
  fi
}
