# audit_remote_shell
#
# Turn off remote shell services
#
# Refer to Section(s) 1.2.7,9 Page(s) 31,33 CIS AIX Benchmark v1.1.0
#.

audit_remote_shell () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Telnet and Rlogin Services"
    if [ "$os_name" = "AIX" ]; then
      check_chsec /etc/security/user root rlogin false
      for user_name in daemon bin sys adm uucp nobody lpd; do
        check_chuser login false rlogin false $user_name
      done
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/network/shell:kshell"
        check_sunos_service $service_name disabled
        service_name="svc:/network/login:eklogin"
        check_sunos_service $service_name disabled
        service_name="svc:/network/login:klogin"
        check_sunos_service $service_name disabled
        service_name="svc:/network/rpc/rex:default"
        check_sunos_service $service_name disabled
        service_name="svc:/network/rexec:default"
        check_sunos_service $service_name disabled
        service_name="svc:/network/shell:default"
        check_sunos_service $service_name disabled
        service_name="svc:/network/login:rlogin"
        check_sunos_service $service_name disabled
        service_name="svc:/network/telnet:default"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      verbose_message "Telnet and Rlogin Services"
      for service_name in telnet login rlogin rsh shell; do
        check_chkconfig_service $service_name 3 off
        check_chkconfig_service $service_name 5 off
      done
    fi
  fi
}
