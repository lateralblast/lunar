#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# full_audit_naming_services
#
# Audit Naming Services
#.

full_audit_naming_services () {
  audit_nis_server
  audit_nis_client
  audit_nisplus
  audit_ldap_cache
  audit_kerberos_tgt
  audit_gss
  audit_keyserv
  audit_dns_client
  audit_dns_server
  audit_krb5
  audit_nis_entries
  audit_avahi_server
  audit_avahi_conf
}
