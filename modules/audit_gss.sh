# audit_gss
#
# The GSS API is a security abstraction layer that is designed to make it
# easier for developers to integrate with different authentication schemes.
# It is most commonly used in applications for sites that use Kerberos for
# network authentication, though it can also allow applications to
# interoperate with other authentication schemes.
# Note: Since this service uses Oracle's standard RPC mechanism, it is
# important that the system's RPC portmapper (rpcbind) also be enabled
# when this service is turned on. This daemon will be taken offline if
# rpcbind is disabled.
#
# GSS does not expose anything external to the system as it is configured
# to use TLI (protocol = ticotsord) by default. However, unless your
# organization is using the GSS API, disable it.
#
# Refer to Section(s) 2.7 Page(s) 19-20 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 2.2.7 Page(s) 27 CIS Solaris 10 v5.1.0
#.

audit_gss () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Generic Security Services"
      service_name="svc:/network/rpc/gss"
      funct_service $service_name disabled
    fi
  fi
}
