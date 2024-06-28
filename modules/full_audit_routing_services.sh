#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# full_audit_routing_services
#
# Audit routing services
#.

full_audit_routing_services () {
  audit_routing_daemons
  audit_routing_params
}
