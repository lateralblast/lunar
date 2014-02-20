# audit_wins
#
# Turn off wins if not required
#.

audit_wins () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "WINS Daemon"
      service_name="svc:/network/wins:default"
      funct_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "RARP Daemon"
    service_name="rarpd"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 5 off
  fi
}
