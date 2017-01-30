# audit_tcp_wrappers
#
# Refer to Section(s) 5.5.1-5  Page(s) 110-114 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 4.5.1-5  Page(s) 95-8    CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 4.5.1-5  Page(s) 86-9    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 3.4.1-5  Page(s) 143-8   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 7.4.1-5  Page(s) 77-80   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.3      Page(s) 3-4     CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.10.1-4 Page(s) 188-192 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.11     Page(s) 22-3    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 2.4      Page(s) 36-7    CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 3.4.1-5  Page(s) 130-4   CIS Amazon Linux Benchmark v2.0.0
#.

audit_tcp_wrappers () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "Darwin" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "TCP Wrappers"
    if [ "$os_name" = "AIX" ]; then
      package_name="netsec.options.tcpwrapper.base"
      funct_lslpp_check $package_name
      if [ "$audit_mode" != 2 ]; then
        total=`expr $total + 1`
        if [ "$lslpp_check" != "$package_name" ]; then
          if [ "$audit_mode" = 1 ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   TCP Wrappers not installed [$insecure Warnings]"
            funct_verbose_message "" fix
            funct_verbose_message "TCP Wrappers not installed" fix
            funct_verbose_message "Install TCP Wrappers" fix
            funct_verbose_message "" fix
            total=`expr $total + 1`
          fi
        else
          secure=`expr $secure + 1`
          echo "Secure:    TCP Wrappers installed [$secure Passes]"
        fi
      fi
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        audit_rpc_bind
        for service_name in `inetadm |awk '{print $3}' |grep "^svc"`; do
          funct_command_value inetadm tcp_wrappers TRUE $service_name
        done
      fi
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/rc.conf"
      funct_file_value $check_file inetd_enable eq YES hash
      funct_file_value $check_file inetd_flags eq "-Wwl -C60" hash
    fi
    check_file="/etc/hosts.deny"
    funct_file_value $check_file ALL colon " ALL" hash
    check_file="/etc/hosts.allow"
    funct_file_value $check_file ALL colon " localhost" hash
    funct_file_value $check_file ALL colon " 127.0.0.1" hash
    if [ ! -f "$check_file" ]; then
      for ip_address in `ifconfig -a |grep 'inet addr' |grep -v ':127.' |awk '{print $2}' |cut -f2 -d":"`; do
        netmask=`ifconfig -a |grep '$ip_address' |awk '{print $3}' |cut -f2 -d":"`
        funct_file_value $check_file ALL colon " $ip_address/$netmask" hash
      done
    fi
    if [ "$os_name" = "AIX" ]; then
      group_name="system"
    else
      group_name="root"
    fi
    funct_check_perms /etc/hosts.deny 0644 root $group_name
    funct_check_perms /etc/hosts.allow 0644 root $group_name
    if [ "$os_name" = "Linux" ]; then
      if [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "SuSE" ] || [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Amazon" ] ; then
        package_name="tcp_wrappers"
        total=`expr $total + 1`
        log_file="$package_name.log"
        funct_linux_package check $package_name
        if [ "$audit_mode" != 2 ]; then
          echo "Checking:  TCP Wrappers is installed"
        fi
        if [ "$package_name" != "tcp_wrappers" ]; then
          if [ "$audit_mode" = 1 ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   TCP Wrappers is not installed [$insecure Warnings]"
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   TCP Wrappers to installed"
            log_file="$work_dir/$log_file"
            echo "Installed $package_name" >> $log_file
            funct_linux_package install $package_name
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            secure=`expr $secure + 1`
            echo "Secure:    TCP Wrappers is installed [$secure Passes]"
          fi
          if [ "$audit_mode" = 2 ]; then
            restore_file="$restore_dir/$log_file"
            funct_linux_package restore $package_name $restore_file
          fi
        fi
      fi
    fi
  fi
}
