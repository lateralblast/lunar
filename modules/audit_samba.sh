# audit_samba
#
# Solaris includes the popular open source Samba server for providing file
# and print services to Windows-based systems. This allows a Solaris system
# to act as a file or print server on a Windows network, and even act as a
# Domain Controller (authentication server) to older Windows operating
# systems. Note that on Solaris releases prior to 11/06 the file
# /etc/sfw/smb.conf does not exist and the service will not be started by
# default even on newer releases.
#
# Refer to Section(s) 3.13 Page(s) 68 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.4.14.4 Page(s) 55 CIS OS X 10.5 Benchmark v1.1.0
# Refer to Section(s) 2.2.9 Page(s) 29-30 CIS Solaris 10 v5.1.0
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
