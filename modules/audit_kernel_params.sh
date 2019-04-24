# audit_kernel_params
#
# Refer to Section(s) 4.2,5.3 Page(s) 16-19    CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.6.1-21 Page(s) 103-131 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 1.6.1-21 Page(s)         CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 3.1.1-18 Page(s) 38-61   CIS Solaris 10 Benchmark v5.1.0
#.

audit_kernel_params () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Kernel Parameters"
    if [ "$os_name" = "AIX" ]; then
      check_no ipsrcrouteforward 0
      check_no ipignoreredirects 1
      check_no clean_partial_conns 1
      check_no ipsrcroutesend 0
      check_no ipforwarding 0
      check_no ipsendredirects 0
      check_no ip6srcrouteforward 0
      check_no directed_broadcast 0
      check_no tcp_pmtu_discover 0
      check_no bcastping 0
      check_no icmpaddressmask 0
      check_no udp_pmtu_discover 0
      check_no ipsrcrouterecv 0
      check_no nonlocsrcroute 0
      check_no tcp_tcpsecure 7
      check_no sockthresh 60
      check_no rfc1323 1
      check_no tcp_sendspace 262144
      check_no tcp_recvspace 262144
      check_no tcp_mssdflt 1448
      check_no portcheck 1
      check_no nfs_use_reserved_ports 1
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/sysctl.conf"
      check_file_value is $check_file kern.securelevel eq 1 hash
      check_file_value is $check_file net.inet.tcp.log_in_vain eq 1 hash
      check_file_value is $check_file net.inet.udp.log_in_vain eq 1 hash
      if [ "$os_version" > 5 ]; then
        check_file_value is $check_file security.bsd.see_other_uids 0 hash
        check_file_value is $check_file security.bsd.see_other_gids 0 hash
      fi
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" != "11" ]; then
        create_nddscript
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
            check_no $parameter_name
          done
        else
          if [ -f "$check_file" ]; then
            check_file_exists $check_file no
          fi
        fi
      fi
    fi
  fi
}
