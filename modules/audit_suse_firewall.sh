# audit_suse_firewall
#
# SuSEfirewall2 is a script that generates IPtables rules from configuration
# stored in the /etc/sysconfig/SuSEfirewall2 file. IPtables is an application
# that allows a system administrator to configure the IPv4 tables, chains and
# rules provided by the Linux kernel firewall.
# IPtables provides extra protection for the Linux system by limiting
# communications in and out of the box to specific IPv4 addresses and ports.
# SuSEfirewall2 is the default interface for SuSE systems and provides
# configuration through YaST in addition to standard configuration files.
# Note: SuSEFirewall2 has limited support for ipv6, if ipv6 is in use in your
# environment consider configuring IPtables and IP6tables directly.
#
# Refer to Section(s) 7.7 Page(s) 83-4 SLES 11 Benchmark v1.0.0
#.

audit_suse_firewall () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "SuSE" ]; then
      funct_verbose_message "SuSE Firewall"
      service_name="SuSEfirewall2_init"
      funct_chkconfig_service $service_name 3 on
      funct_chkconfig_service $service_name 5 on
      service_name="SuSEfirewall2_setup"
      funct_chkconfig_service $service_name 3 on
      funct_chkconfig_service $service_name 5 on
    fi
  fi
}
