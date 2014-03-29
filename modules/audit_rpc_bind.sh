# audit_rpc_bind
#
# The rpcbind utility is a server that converts RPC program numbers into
# universal addresses. It must be running on the host to be able to make
# RPC calls on a server on that machine.
# When an RPC service is started, it tells rpcbind the address at which it is
# listening, and the RPC program numbers it is prepared to serve. When a client
# wishes to make an RPC call to a given program number, it first contacts
# rpcbind on the server machine to determine the address where RPC requests
# should be sent.
# The rpcbind utility should be started before any other RPC service. Normally,
# standard RPC servers are started by port monitors, so rpcbind must be started
# before port monitors are invoked.
# Check that rpc bind has tcp wrappers enabled in case it's turned on.
#
# Refer to Section(s) 2.2.14 Page(s) 34-5 CIS Solaris 10 v5.1.0
#.

audit_rpc_bind () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "RPC Bind"
      service_name="svc:/network/rpc/bind"
      service_property="config/enable_tcpwrappers"
      correct_value="true"
      audit_svccfg_value $service_name $service_property $correct_value
    fi
    if [ "$os_version" = "11" ]; then
      service_name="svc:/network/rpc/bind"
      funct_service $service_name disabled
    fi
  fi
}
