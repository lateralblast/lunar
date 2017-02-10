# audit_boot_server
#
# Turn off boot services
#.

audit_boot_server () {
  audit_rarp
  audit_bootparams
  audit_tftp_server
  audit_dhcp_server
}
