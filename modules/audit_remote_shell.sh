# audit_remote_shell
#
# Turn off remote shell services
#.

audit_remote_shell () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Telnet and Rlogin Services"
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
}
