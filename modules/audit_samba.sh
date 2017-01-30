# audit_samba
#
# Refer to Section(s) 3.13     Page(s) 68    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.13     Page(s) 80    CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 2.2.12   Page(s) 112   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 6.12     Page(s) 60-1  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.4.14.4 Page(s) 55    CIS OS X 10.5 Benchmark v1.1.0
# Refer to Section(s) 2.2.9    Page(s) 29-30 CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 2.2.12-3 Page(s) 104-5 CIS Amazon Linux Benchmark v2.0.0
#.

audit_samba () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        funct_verbose_message "Samba Daemons"
      fi
      if [ "$os_version" = "10" ]; then
        if [ $os_update -ge 4 ]; then
          service_name="svc:/network/samba"
          funct_service $service_name disabled
        else
          service_name="samba"
          funct_service $service_name disabled
        fi
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      funct_verbose_message "Samba Daemons"
      service_name="smb"
      funct_systemctl_service disable $service_name
      funct_chkconfig_service $service_name 3 off
      funct_chkconfig_service $service_name 5 off
      if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
        funct_linux_package uninstall samba
      fi
    fi
    for check_dir in /etc /etc/sfw /etc/samba /usr/local/etc /usr/sfw/etc /opt/sfw/etc; do
      check_file="$check_dir/smb.conf"
      if [ -f "$check_file" ]; then
        funct_file_value $check_file "restrict anonymous" eq 2 semicolon after "\[Global\]"
        funct_file_value $check_file "guest OK" eq no semicolon after "\[Global\]"
        funct_file_value $check_file "client ntlmv2 auth" eq yes semicolon after "\[Global\]"
      fi
    done
  fi
}
