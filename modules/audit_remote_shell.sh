# audit_remote_shell
#
# Turn off remote shell services
#
# Refer to Section(s) 1.2.7,9 Page(s) 31,33 CIS AIX Benchmark v1.1.0
#.

audit_remote_shell () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Telnet and Rlogin Services"
    if [ "$os_name" = "AIX" ]; then
      funct_chsec_check /etc/security/user root rlogin false
      for user_name in daemon bin sys adm uucp nobody lpd; do
        funct_chuser_check login false rlogin false $user_name
      done
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/network/shell:kshell"
        funct_service $service_name disabled
        service_name="svc:/network/login:eklogin"
        funct_service $service_name disabled
        service_name="svc:/network/login:klogin"
        funct_service $service_name disabled
        service_name="svc:/network/rpc/rex:default"
        funct_service $service_name disabled
        service_name="svc:/network/rexec:default"
        funct_service $service_name disabled
        service_name="svc:/network/shell:default"
        funct_service $service_name disabled
        service_name="svc:/network/login:rlogin"
        funct_service $service_name disabled
        service_name="svc:/network/telnet:default"
        funct_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      funct_verbose_message "Telnet and Rlogin Services"
      for service_name in telnet login rlogin rsh shell; do
        funct_chkconfig_service $service_name 3 off
        funct_chkconfig_service $service_name 5 off
      done
    fi
  fi
}
