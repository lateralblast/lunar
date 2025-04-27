#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# full_audit_web_services
#
# Audit web services

full_audit_web_services () {
  audit_webconsole
  audit_wbem
  audit_apache
  audit_webmin
}
