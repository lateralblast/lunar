# audit_kernel_params
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
