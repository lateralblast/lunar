#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# full_audit_network_services
#
# Audit Network Service
#.

full_audit_network_services () {
  print_function "full_audit_network_services"
  audit_snmp
  audit_ntp
  audit_ipmi
  audit_echo
  audit_ocfserv
  audit_tname
  audit_service_tags
  audit_ticotsord
  audit_boot_server
  audit_slp
  audit_tnd
  audit_nobody_rpc
  audit_dhcpcd
  audit_dhcprd
  audit_dhcpsd
  audit_mob
  audit_dvfilter
  audit_wireless
  audit_ufw
}
