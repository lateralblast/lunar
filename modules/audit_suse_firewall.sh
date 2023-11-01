# audit_suse_firewall
#
# Check SuSE Firewall enabled
#
# Refer to Section(s) 7.7 Page(s) 83-4 SLES 11 Benchmark v1.0.0
#.

audit_suse_firewall () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "SuSE" ]; then
      verbose_message "SuSE Firewall"
      for service_name in "SuSEfirewall2_init" "SuSEfirewall2_setup"; do
        check_linux_service $service_name on
      done
    fi
  fi
}
