# audit_cde_spc
#
# CDE Subprocess control. Not required unless running CDE applications.
#.

audit_cde_spc () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "Subprocess control"
      service_name="svc:/network/cde-spc:default"
      funct_service $service_name disabled
    fi
  fi
}
