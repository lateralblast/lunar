#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# full_audit_firewall_services
#
# Audit firewall related services
#.

full_audit_firewall_services () {
  audit_ipsec
  audit_ipfilter
  audit_tcp_wrappers
  audit_iptables
  audit_ipfw
  audit_suse_firewall
}
