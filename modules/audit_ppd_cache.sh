# audit_ppd_cache
#
# Cache for Printer Descriptions. Not required unless using print services.
#.

audit_ppd_cache () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      verbose_message "PPD Cache"
      service_name="svc:/application/print/ppd-cache-update:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
