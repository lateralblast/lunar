# audit_routing_params
#
# Network Routing
# Source Packet Forwarding
# Directed Broadcast Packet Forwarding
# Response to ICMP Timestamp Requests
# Response to ICMP Broadcast Timestamp Requests
# Response to ICMP Broadcast Netmask Requests
# Response to Broadcast ICMPv4 Echo Request
# Response to Multicast Echo Request
# Ignore ICMP Redirect Messages
# Strict Multihoming
# ICMP Redirect Messages
# TCP Reverse IP Source Routing
# Maximum Number of Half-open TCP Connections
# Maximum Number of Incoming Connections
#
# The network routing daemon, in.routed, manages network routing tables.
# If enabled, it periodically supplies copies of the system's routing tables
# to any directly connected hosts and networks and picks up routes supplied
# to it from other networks and hosts.
# Routing Internet Protocol (RIP) is a legacy protocol with a number of
# security issues (e.g. no authentication, no zoning, and no pruning).
# Routing (in.routed) is disabled by default in all Solaris 10 systems,
# if there is a default router defined. If no default gateway is defined
# during system installation, network routing is enabled.
#
# Refer to Section(s) 3.4-17 Page(s) 28-39 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 3.5    Page(s) 64-5  CIS Solaris 10 Benchmark v5.1.0
#.

audit_routing_params () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "IP Routing"
      funct_command_value routeadm ipv4-routing disabled
      funct_command_value routeadm ipv6-routing disabled
      funct_verbose_message "IP Forwarding"
      funct_command_value routeadm ipv4-forwarding disabled
      funct_command_value routeadm ipv6-forwarding disabled
      funct_file_exists /etc/notrouter yes
    fi
    if [ "$os_version" = "11" ]; then
      funct_verbose_message "IP Routing"
      audit_ipadm_value _forward_src_routed ipv4 0
      audit_ipadm_value _forward_src_routed ipv6 0
      audit_ipadm_value _rev_src_routes tcp 0
      funct_verbose_message "Broadcasting"
      audit_ipadm_value _forward_directed_broadcasts ip 0
      audit_ipadm_value _respond_to_timestamp ip 0
      audit_ipadm_value _respond_to_timestamp_broadcast ip 0
      audit_ipadm_value _respond_to_address_mask_broadcast ip 0
      audit_ipadm_value _respond_to_echo_broadcast ip 0
      funct_verbose_message "Multicasting"
      audit_ipadm_value _respond_to_echo_multicast ipv4 0
      audit_ipadm_value _respond_to_echo_multicast ipv6 0
      funct_verbose_message "IP Redirecting"
      audit_ipadm_value _ignore_redirect ipv4 1
      audit_ipadm_value _ignore_redirect ipv6 1
      audit_ipadm_value _send_redirects ipv4 0
      audit_ipadm_value _send_redirects ipv6 0
      funct_verbose_message "Multihoming"
      audit_ipadm_value _strict_dst_multihoming ipv4 1
      audit_ipadm_value _strict_dst_multihoming ipv6 1
      funct_verbose_message "Queue Sizing"
      audit_ipadm_value _conn_req_max_q0 tcp 4096
      audit_ipadm_value _conn_req_max_q tcp 1024
    fi
  fi
}
