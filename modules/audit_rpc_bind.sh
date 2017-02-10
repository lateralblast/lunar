# audit_rpc_bind
#
# Check that rpc bind has tcp wrappers enabled in case it's turned on.
#
# Refer to Section(s) 2.2.14 Page(s) 34-5 CIS Solaris 10 Benchmark v5.1.0
#.

audit_rpc_bind () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "RPC Bind"
      service_name="svc:/network/rpc/bind"
      service_property="config/enable_tcpwrappers"
      correct_value="true"
      audit_svccfg_value $service_name $service_property $correct_value
    fi
    if [ "$os_version" = "11" ]; then
      service_name="svc:/network/rpc/bind"
      check_sunos_service $service_name disabled
    fi
  fi
}
