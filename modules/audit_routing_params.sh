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
# Refer to Section(s) 3.4-17 Page(s) 28-39 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 3.5    Page(s) 64-5  CIS Solaris 10 Benchmark v5.1.0
#.

audit_routing_params () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "IP Routing"
      check_command_value routeadm ipv4-routing disabled
      check_command_value routeadm ipv6-routing disabled
      verbose_message "IP Forwarding"
      check_command_value routeadm ipv4-forwarding disabled
      check_command_value routeadm ipv6-forwarding disabled
      check_file_exists /etc/notrouter yes
    fi
    if [ "$os_version" = "11" ]; then
      verbose_message "IP Routing"
      audit_ipadm_value _forward_src_routed ipv4 0
      audit_ipadm_value _forward_src_routed ipv6 0
      audit_ipadm_value _rev_src_routes tcp 0
      verbose_message "Broadcasting"
      audit_ipadm_value _forward_directed_broadcasts ip 0
      audit_ipadm_value _respond_to_timestamp ip 0
      audit_ipadm_value _respond_to_timestamp_broadcast ip 0
      audit_ipadm_value _respond_to_address_mask_broadcast ip 0
      audit_ipadm_value _respond_to_echo_broadcast ip 0
      verbose_message "Multicasting"
      audit_ipadm_value _respond_to_echo_multicast ipv4 0
      audit_ipadm_value _respond_to_echo_multicast ipv6 0
      verbose_message "IP Redirecting"
      audit_ipadm_value _ignore_redirect ipv4 1
      audit_ipadm_value _ignore_redirect ipv6 1
      audit_ipadm_value _send_redirects ipv4 0
      audit_ipadm_value _send_redirects ipv6 0
      verbose_message "Multihoming"
      audit_ipadm_value _strict_dst_multihoming ipv4 1
      audit_ipadm_value _strict_dst_multihoming ipv6 1
      verbose_message "Queue Sizing"
      audit_ipadm_value _conn_req_max_q0 tcp 4096
      audit_ipadm_value _conn_req_max_q tcp 1024
    fi
  fi
}
