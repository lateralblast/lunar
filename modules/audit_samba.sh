# audit_samba
#
# Refer to Section(s) 3.13     Page(s) 68    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.13     Page(s) 80    CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 2.2.12   Page(s) 112   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 6.12     Page(s) 60-1  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.4.14.4 Page(s) 55    CIS OS X 10.5 Benchmark v1.1.0
# Refer to Section(s) 2.2.9    Page(s) 29-verbose_message " CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 2.2.12-3 Page(s) 104-5 CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.12-3 Page(s) 112-3 CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_samba () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    verbose_message "Samba Daemons"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        if [ $os_update -ge 4 ]; then
          service_name="svc:/network/samba"
          check_sunos_service $service_name disabled
        else
          service_name="samba"
          check_sunos_service $service_name disabled
        fi
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      service_name="smb"
      check_systemctl_service disable $service_name
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
      check_linux_package uninstall samba
    fi
    for check_dir in /etc /etc/sfw /etc/samba /usr/local/etc /usr/sfw/etc /opt/sfw/etc; do
      check_file="$check_dir/smb.conf"
      if [ -f "$check_file" ]; then
        check_file_value is $check_file "restrict anonymous" eq 2 semicolon after "\[Global\]"
        check_file_value is $check_file "guest OK" eq no semicolon after "\[Global\]"
        check_file_value is $check_file "client ntlmv2 auth" eq yes semicolon after "\[Global\]"
      fi
    done
  fi
}
