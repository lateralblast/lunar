# audit_cde_cal () {
#
# Refer to Section(s) 2.1.2 Page(s) 18-9 CIS Solaris 10 v5.1.0
#.

audit_cde_cal () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      verbose_message "Local CDE Calendar Manager"
      service_name="svc:/network/rpc/cde-calendar-manager:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
