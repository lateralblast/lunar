# audit_cde_print
#
# CDE Printing services. Not required unless running CDE applications.
#.

audit_cde_print () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      verbose_message "CDE Print"
      service_name="svc:/application/cde-printinfo:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
