# audit_suse_firewall
#
# Refer to Section(s) 7.7 Page(s) 83-4 SLES 11 Benchmark v1.0.0
#.

audit_suse_firewall () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "SuSE" ]; then
      verbose_message "SuSE Firewall"
      service_name="SuSEfirewall2_init"
      check_chkconfig_service $service_name 3 on
      check_chkconfig_service $service_name 5 on
      service_name="SuSEfirewall2_setup"
      check_chkconfig_service $service_name 3 on
      check_chkconfig_service $service_name 5 on
    fi
  fi
}
