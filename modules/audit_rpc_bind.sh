#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_rpc_bind
#
# Check that rpc bind has tcp wrappers enabled in case it's turned on.
#
# Refer to Section(s) 2.2.14 Page(s) 34-5 CIS Solaris 10 Benchmark v5.1.0
#.

audit_rpc_bind () {
  print_module "audit_rpc_bind"
  if [ "${os_name}" = "SunOS" ]; then
    verbose_message "RPC Bind" check
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      audit_svccfg_value  "svc:/network/rpc/bind" "config/enable_tcpwrappers" "true"
    fi
    if [ "${os_version}" = "11" ]; then
      check_sunos_service "svc:/network/rpc/bind" "disabled"
    fi
  fi
}
