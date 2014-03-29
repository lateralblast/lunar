# audit_keyserv
#
# The keyserv process is only required for sites that are using
# Oracle's Secure RPC mechanism. The most common uses for Secure RPC on
# Solaris machines are NIS+ and "secure NFS", which uses the Secure RPC
# mechanism to provide higher levels of security than the standard NFS
# protocols. Do not confuse "secure NFS" with sites that use Kerberos
# authentication as a mechanism for providing higher levels of NFS security.
# "Kerberized" NFS does not require the keyserv process to be running.
#
# Refer to Section(s) 2.3 Page(s) 16-17 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 2.2.1 Page(s) 23 CIS Solaris 10 v5.1.0
#.

audit_keyserv () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "RPC Encryption Key"
      service_name="svc:/network/rpc/keyserv"
      funct_service $service_name disabled
    fi
  fi
}
