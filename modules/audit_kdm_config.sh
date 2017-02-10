# audit_kdm_config
#
# Turn off kdm config
#.

audit_kdm_config () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "Graphics Configuration"
      service_name="svc:/platform/i86pc/kdmconfig:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
