# audit_tcp_wrappers
#
# TCP Wrappers is a host-based access control system that allows administrators
# to control who has access to various network services based on the IP address
# of the remote end of the connection. TCP Wrappers also provide logging
# information via syslog about both successful and unsuccessful connections.
# Rather than enabling TCP Wrappers for all services with "inetadm -M ...",
# the administrator has the option of enabling TCP Wrappers for individual
# services with "inetadm -m <svcname> tcp_wrappers=TRUE", where <svcname> is
# the name of the specific service that uses TCP Wrappers.
#
# TCP Wrappers provides more granular control over which systems can access
# services which limits the attack vector. The logs show attempted access to
# services from non-authorized systems, which can help identify unauthorized
# access attempts.
#
# The /etc/hosts.allow file specifies which IP addresses are permitted to
# connect to the host. It is intended to be used in conjunction with the
# /etc/hosts.deny file.
# The /etc/hosts.allow file supports access control by IP and helps ensure
# that only authorized systems can connect to the server.
# The /etc/hosts.allow file contains networking information that is used by
# many applications and therefore must be readable for these applications to
# operate.
# It is critical to ensure that the /etc/hosts.allow file is protected from
# unauthorized write access. Although it is protected by default, the file
# permissions could be changed either inadvertently or through malicious actions.
#
# The /etc/hosts.deny file specifies which IP addresses are not permitted to
# connect to the host. It is intended to be used in conjunction with the
# /etc/hosts.allow file.
# The /etc/hosts.deny file serves as a failsafe so that any host not specified
# in /etc/hosts.allow is denied access to the server.
# The /etc/hosts.deny file contains network information that is used by many
# system applications and therefore must be readable for these applications to
# operate.
# It is critical to ensure that the /etc/hosts.deny file is protected from
# unauthorized write access. Although it is protected by default, the file
# permissions could be changed either inadvertently or through malicious actions.
#
# Refer to Section(s) 5.5.1-5 Page(s) 110-114 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.3 Page(s) 3-4 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.10.1-4 Page(s) 188-192 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.11 Page(s) 22-23 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 2.4 Page(s) 36-7 CIS Solaris 10 v5.1.0
#.

audit_tcp_wrappers () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "Darwin" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "TCP Wrappers"
    if [ "$os_name" = "AIX" ]; then
      package_name="netsec.options.tcpwrapper.base"
      funct_lslpp_check $package_name
      if [ "$lslpp_check" = "$package_name" ]; then
      else
        funct_verbose_message "" fix
        funct_verbose_message "TCP Wrappers not installed" fix
        funct_verbose_message "" fix
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
    funct_file_perms /etc/hosts.deny 0644 root $group_name
    funct_file_perms /etc/hosts.allow 0644 root $group_name
    if [ "$os_name" = "Linux" ]; then
      if [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "SuSE" ] || [ "$os_vendor" = "CentOS" ]; then
        package_name="tcp_wrappers"
        total=`expr $total + 1`
        log_file="$package_name.log"
        funct_linux_package check $package_name
        if [ "$audit_mode" != 2 ]; then
          echo "Checking:  TCP Wrappers is installed"
        fi
        if [ "$package_name" != "tcp_wrappers" ]; then
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score - 1`
            echo "Warning:   TCP Wrappers is not installed [$score]"
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   TCP Wrappers to installed"
            log_file="$work_dir/$log_file"
            echo "Installed $package_name" >> $log_file
            funct_linux_package install $package_name
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score + 1`
            echo "Secure:    TCP Wrappers is installed [$score]"
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
