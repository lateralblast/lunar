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
}
