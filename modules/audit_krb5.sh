#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_krb5
#
# Turn off kerberos if not required
#.

audit_krb5 () {
  print_function "audit_krb5"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    verbose_message "Kerberos" "check"
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
        for service_name in "svc:/network/security/krb5kdc:default" \
          "svc:/network/security/kadmin:default" \
          "svc:/network/security/krb5_prop:default"; do
          check_sunos_service "${service_name}" "disabled"
        done
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      for service_name in kadmin kprop krb524 krb5kdc; do
        check_linux_service "${service_name}" "off"
      done
    fi
  fi
}
