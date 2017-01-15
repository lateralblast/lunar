# audit_kernel_params
#
# Solaris:
#
# Network device drivers have parameters that can be set to provide stronger
# security settings, depending on environmental needs. This section describes
# modifications to network parameters for IP, ARP and TCP.
# The settings described in this section meet most functional needs while
# providing additional security against common network attacks. However,
# it is important to understand the needs of your particular environment
# to determine if these settings are appropriate for you.
#
# The ip_forward_src_routed and ip6_forward_src_routed parameters control
# whether IPv4/IPv6 forwards packets with source IPv4/IPv6 routing options
# Keep this parameter disabled to prevent denial of service attacks through
# spoofed packets.
#
# The ip_forward_directed_broadcasts parameter controls whether or not Solaris
# forwards broadcast packets for a specific network if it is directly connected
# to the machine.
# The default value of 1 causes Solaris to forward broadcast packets.
# An attacker could send forged packets to the broadcast address of a remote
# network, resulting in a broadcast flood. Setting this value to 0 prevents
# Solaris from forwarding these packets. Note that disabling this parameter
# also disables broadcast pings.
#
# The ip_respond_to_timestamp parameter controls whether or not to respond to
# ICMP timestamp requests.
# Reduce attack surface by restricting a vector for host discovery.
#
# The ip_respond_to_timestamp_broadcast parameter controls whether or not to
# respond to ICMP broadcast timestamp requests.
# Reduce attack surface by restricting a vector for bulk host discovery.
#
# The ip_respond_to_address_mask_broadcast parameter controls whether or not
# to respond to ICMP netmask requests, typically sent by diskless clients when
# booting.
# An attacker could use the netmask information to determine network topology.
# The default value is 0.
#
# The ip6_send_redirects parameter controls whether or not IPv6 sends out
# ICMPv6 redirect messages.
# A malicious user can exploit the ability of the system to send ICMP redirects
# by continually sending packets to the system, forcing the system to respond
# with ICMP redirect messages, resulting in an adverse impact on the CPU and
# performance of the system.
#
# The ip_respond_to_echo_broadcast parameter controls whether or not IPv4
# responds to a broadcast ICMPv4 echo request.
# Responding to echo requests verifies that an address is valid, which can aid
# attackers in mapping out targets. ICMP echo requests are often used by
# network monitoring applications.
#
# The ip6_respond_to_echo_multicast and ip_respond_to_echo_multicast parameters
# control whether or not IPv6 or IPv4 responds to a multicast IPv6 or IPv4 echo
# request.
# Responding to multicast echo requests verifies that an address is valid,
# which can aid attackers in mapping out targets.
#
# The ip_ire_arp_interval parameter determines the intervals in which Solaris
# scans the IRE_CACHE (IP Resolved Entries) and deletes entries that are more
# than one scan old. This interval is used for solicited arp entries, not
# un-solicited which are handled by arp_cleanup_interval.
# This helps mitigate ARP attacks (ARP poisoning). Consult with your local
# network team for additional security measures in this area, such as using
# static ARP, or fixing MAC addresses to switch ports.
#
# The ip_ignore_redirect and ip6_ignore_redirect parameters determine if
# redirect messages will be ignored. ICMP redirect messages cause a host to
# re-route packets and could be used in a DoS attack. The default value for
# this is 0. Setting this parameter to 1 causes redirect messages to be
# ignored.
# IP redirects should not be necessary in a well-designed, well maintained
# network. Set to a value of 1 if there is a high risk for a DoS attack.
# Otherwise, the default value of 0 is sufficient.
#
# The ip_strict_dst_multihoming and ip6_strict_dst_multihoming parameters
# determines whether a packet arriving on a non -forwarding interface can be
# accepted for an IP address that is not explicitly configured on that
# interface. If ip_forwarding is enabled, or xxx:ip_forwarding (where xxx is
# the interface name) for the appropriate interfaces is enabled, then this
# parameter is ignored because the packet is actually forwarded.
# Set this parameter to 1 for systems that have interfaces that cross strict
# networking domains (for example, a firewall or a VPN node).
#
# The ip_send_redirects parameter controls whether or not IPv4 sends out
# ICMPv4 redirect messages.
# A malicious user can exploit the ability of the system to send ICMP
# redirects by continually sending packets to the system, forcing the system
# to respond with ICMP redirect messages, resulting in an adverse impact on
# the CPU performance of the system.
#
# The arp_cleanup_interval parameter controls the length of time, in
# milliseconds, that an unsolicited Address Resolution Protocal (ARP)
# request remains in the ARP cache.
# If unsolicited ARP requests are allowed to remain in the ARP cache for long
# periods an attacker could fill up the ARP cache with bogus entries.
# Set this parameter to 60000 ms (1 minute) to reduce the effectiveness of ARP
# attacks. The default value is 300000.
#
# The tcp_rev_src_routes parameter determines if TCP reverses the IP source
# routing option for incoming connections. If set to 0, TCP does not reverse
# IP source. If set to 1, TCP does the normal reverse source routing.
# The default setting is 0.
# If IP source routing is needed for diagnostic purposes, enable it.
# Otherwise leave it disabled.
#
# The tcp_conn_req_max_q0 parameter determines how many half-open TCP
# connections can exist for a port. This setting is closely related with
# tcp_conn_req_max_q.
# It is necessary to control the number of completed connections to the system
# to provide some protection against Denial of Service attacks. Note that the
# value of 4096 is a minimum to establish a good security posture for this
# setting. In environments where connections numbers are high, such as a busy
# webserver, this value may need to be increased.
#
# The tcp_conn_req_max_q parameter determines the maximum number of incoming
# connections that can be accepted on a port. This setting is closely related
# with tcp_conn_req_max_q0.
# Restricting the number of "half open" connections limits the damage of DOS
# attacks where the attacker floods the network with "SYNs". Having this split
# from the tcp_conn_req_max_q parameter allows the administrator some discretion
# in this area.
# Note that the value of 1024 is a minimum to establish a good security posture
# for this setting. In environments where connections numbers are high, such as
# a busy webserver, this value may need to be increased.
#
# FreeBSD:
#
# FreeBSD offers a securelevel feature which will set a default system security
# profile. Setting this to a value of one (1) will set the system immutable and
# system append-only flags on files (see the chflags manual page). These flags
# cannot be turned off once this is set, and certain devices, for instance
# /dev/mem, may not be opened for writing.
#
# Block users from viewing unowned processes
#
# Block users from viewing processes in other groups
#
# AIX:
#
# The ipsrcrouteforward will be set to 0, to prevent source-routed packets
# being forwarded by the system. This would prevent a hacker from using
# source-routed packets to bridge an external facing server to an internal LAN,
# possibly even through a firewall.
#
# The ipignoreredirects will be set to 1, to prevent IP re-directs being
# processed by the system.
#
# The clean_partial_conns parameter determines whether or not the system is
# open to SYN attacks. This parameter, when enabled, clears down connections
# in the SYN RECEIVED state after a set period of time. This attempts to stop
# DoS attacks when a hacker may flood a system with SYN flag set packets.
#
# The ipsrcroutesend parameter will be set to 0, to ensure that any local
# applications cannot send source routed packets.
#
# The ipforwarding parameter will be set to 0, to ensure that redirected
# packets do not reach remote networks. This should only be enabled if the
# system is performing the function of an IP router. This is typically handled
# by a dedicated network device.
#
# The ipsendredirects parameter will be set to 0, to ensure that redirected
# packets do not reach remote networks.
#
# The ip6srcrouteforward parameter will be set to 0, to prevent source-routed
# packets being forwarded by the system. This would prevent a hacker from using
# source-routed packets to bridge an external facing server to an internal LAN,
# possibly even through a firewall.
#
# The directed_broadcast parameter will be set to 0, to prevent directed
# broadcasts being sent network gateways. This would prevent a redirected
# packet from reaching a remote network.
#
# The tcp_pmtu_discover parameter will be set to 0. The idea of MTU discovery
# is to avoid packet fragmentation between remote networks. This is achieved
# by discovering the network route and utilizing the smallest MTU size within
# that path when transmitting packets. When tcp_pmtu_discover is enabled,
# it leaves the system vulnerable to source routing attacks.
#
# The bcastping parameter will be set to 0. This means that the system will
# not respond to ICMP packets sent to the broadcast address. By default, when
# this is enabled the system is susceptible to smurf attacks, where a hacker
# utilizes this tool to send a small number of ICMP echo packets.
# These packets can generate huge numbers of ICMP echo replies and seriously
# affect the performance of the targeted host and network. This parameter will
# be disabled to ensure protection from this type of attack.
#
# The icmpaddressmask parameter will be set to 0, This means that the system
# will not respond to ICMP address mask request pings. By default, when this
# is enabled the system is susceptible to source routing attacks.
# This is typically a feature performed by a device such as a network router
# and should not be enabled within the operating system.
#
# The udp_pmtu_discover parameter will be set to 0. The idea of MTU discovery
# is to avoid packet fragmentation between remote networks. This is achieved
# by discovering the network route and utilizing the smallest MTU size within
# that path when transmitting packets. When udp_pmtu_discover is enabled, it
# leaves the system vulnerable to source routing attacks.
#
# The ipsrcrouterecv parameter will be set to 0, This means that the system
# will not accept source routed packets. By default, when this is enabled the
# system is susceptible to source routing attacks.
#
# The nonlocsrcroute parameter will be set to 0. This means that the system
# will not allow source routed packets to be addressed to hosts outside of
# the LAN. By default, when this is enabled the system is susceptible to
# source routing attacks.
#
# The tcp_tcpsecure parameter value determines if the system is protected
# from three specific vulnerabilities:
#
# Fake SYN – This is used to terminate an established connection.
# A tcp_tcpsecure value of 1 protects the system from this vulnerability.
#
# Fake RST – As above, this is used to terminate an established connection.
# A tcp_tcpsecure value of 2 protects the system from this vulnerability.
#
# Fake data – A hacker may inject fake data into an established connection.
# A tcp_tcpsecure value of 4 protects the system from this vulnerability.
#
# The tcp_tcpsecure parameter will be set to 7. This means that the system
# will be protected from any connection reset and data integrity attacks.
#
# The sockthresh parameter will be set to 60. This means that 60% of network
# memory can be used to service new socket connections, the remaining 40% is
# reserved for existing sockets. This ensures a quality of service for existing
# connections.
#
# The rfc1323 parameter will be set to 1. This means that the system will
# allow the TCP windows sizes to exceed 64KB. This is a requirement for high
# performance networks, particularly those which utilize large MTU sizes.
#
# The tcp_sendspace parameter will be set to 262144. This means that the system
# default socket buffer size for sending data will be 262KB.
# This is the minimum recommendation for modern high performance networks.
#
# The tcp_recvspace parameter will be set to 262144. This means that the system
# default socket buffer size for receiving data will be 262KB.
# This is the minimum recommendation for modern high performance networks.
#
# The tcp_mssdflt parameter will be set to 1448.
# This value reflects the packet size minus the TCP/IP headers.
#
# The portcheck and nfs_use_reserved_ports parameters will both be set to 1.
# This value means that NFS client requests that do not originate from the
# privileged ports range (ports less than 1024) will be ignored by the local
# system.
#
# Refer to Section(s) 4.2,5.3 Page(s) 16-19    CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.6.1-21 Page(s) 103-131 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 1.6.1-21 Page(s)         CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 3.1.1-18 Page(s) 38-61   CIS Solaris 10 Benchmark v5.1.0
#.

audit_kernel_params () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "Kernel Parameters"
    if [ "$os_name" = "AIX" ]; then
      funct_no_check ipsrcrouteforward 0
      funct_no_check ipignoreredirects 1
      funct_no_check clean_partial_conns 1
      funct_no_check ipsrcroutesend 0
      funct_no_check ipforwarding 0
      funct_no_check ipsendredirects 0
      funct_no_check ip6srcrouteforward 0
      funct_no_check directed_broadcast 0
      funct_no_check tcp_pmtu_discover 0
      funct_no_check bcastping 0
      funct_no_check icmpaddressmask 0
      funct_no_check udp_pmtu_discover 0
      funct_no_check ipsrcrouterecv 0
      funct_no_check nonlocsrcroute 0
      funct_no_check tcp_tcpsecure 7
      funct_no_check sockthresh 60
      funct_no_check rfc1323 1
      funct_no_check tcp_sendspace 262144
      funct_no_check tcp_recvspace 262144
      funct_no_check tcp_mssdflt 1448
      funct_no_check portcheck 1
      funct_no_check nfs_use_reserved_ports 1
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/sysctl.conf"
      funct_file_value $check_file kern.securelevel eq 1 hash
      funct_file_value $check_file net.inet.tcp.log_in_vain eq 1 hash
      funct_file_value $check_file net.inet.udp.log_in_vain eq 1 hash
      if [ "$os_version" > 5 ]; then
        funct_file_value $check_file security.bsd.see_other_uids 0 hash
        funct_file_value $check_file security.bsd.see_other_gids 0 hash
      fi
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" != "11" ]; then
        funct_create_nddscript
        check_file="/etc/init.d/ndd-netconfig"
        rcd_file="/etc/rc2.d/S99ndd-netconfig"
        audit_ndd_value /dev/ip ip_forward_src_routed 0
        audit_ndd_value /dev/ip ip_forwarding 0
        if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
          audit_ndd_value /dev/ip ip6_forward_src_routed 0
          audit_ndd_value /dev/tcp tcp_rev_src_routes 0
          audit_ndd_value /dev/ip ip6_forwarding 0
        fi
        audit_ndd_value /dev/ip ip_forward_directed_broadcasts 0
        audit_ndd_value /dev/tcp tcp_conn_req_max_q0 4096
        audit_ndd_value /dev/tcp tcp_conn_req_max_q 1024
        audit_ndd_value /dev/ip ip_respond_to_timestamp 0
        audit_ndd_value /dev/ip ip_respond_to_timestamp_broadcast 0
        audit_ndd_value /dev/ip ip_respond_to_address_mask_broadcast 0
        audit_ndd_value /dev/ip ip_respond_to_echo_multicast 0
        if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
          audit_ndd_value /dev/ip ip6_respond_to_echo_multicast 0
        fi
        audit_ndd_value /dev/ip ip_respond_to_echo_broadcast 0
        audit_ndd_value /dev/arp arp_cleanup_interval 60000
        audit_ndd_value /dev/ip ip_ire_arp_interval 60000
        audit_ndd_value /dev/ip ip_ignore_redirect 1
        if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
          audit_ndd_value /dev/ip ip6_ignore_redirect 1
        fi
        audit_ndd_value /dev/tcp tcp_extra_priv_ports_add 6112
        audit_ndd_value /dev/ip ip_strict_dst_multihoming 1
        if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
          audit_ndd_value /dev/ip ip6_strict_dst_multihoming 1
        fi
        audit_ndd_value /dev/ip ip_send_redirects 0
        if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
          audit_ndd_value /dev/ip ip6_send_redirects 0
        fi
      fi
      if [ "$audit_mode" = 2 ]; then
        if [ "$os_name" = "AIX" ]; then
          for parameter_name in ipsrcrouteforward ipignoreredirects \
          clean_partial_conns ipsrcroutesend ipforwarding ipsendredirects \
          ip6srcrouteforward directed_broadcast tcp_pmtu_discover bcastping \
          icmpaddressmask udp_pmtu_discover ipsrcrouterecv nonlocsrcroute \
          tcp_tcpsecure sockthresh rfc1323 tcp_sendspace tcp_recvspace \
          tcp_mssdflt portcheck nfs_use_reserved_ports; do
            funct_no_check $parameter_name
          done
        else
          if [ -f "$check_file" ]; then
            funct_file_exists $check_file no
          fi
        fi
      fi
    fi
  fi
}
