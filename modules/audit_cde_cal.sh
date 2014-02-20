# audit_cde_cal () {
#
# CDE Calendar Manager is an appointment and resource scheduling tool.
# Not required unless running CDE applications.
#.

audit_cde_cal () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "Local CDE Calendar Manager"
      service_name="svc:/network/rpc/cde-calendar-manager:default"
      funct_service $service_name disabled
    fi
  fi
}
