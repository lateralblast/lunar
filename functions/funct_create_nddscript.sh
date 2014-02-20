# funct_create_nddscript
#
# Creates an ndd boot script for Solaris
#
#.

funct_create_nddscript () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" != "11" ]; then
      funct_verbose_message "Kernel ndd Parameters"
      check_file="/etc/init.d/ndd-netconfig"
      rcd_file="/etc/rc2.d/S99ndd-netconfig"
      if [ "$audit_mode" = 0 ]; then
        if [ ! -f "$check_file" ]; then
          echo "Creating:  Init script $check_file"
          echo "#!/sbin/sh" > $check_file
          echo "case \"\$1\" in" >> $check_file
          echo "start)" >> $check_file
          echo "\t/usr/sbin/ndd -set /dev/ip ip_forward_src_routed 0" >> $check_file
          echo "\t/usr/sbin/ndd -set /dev/ip ip_forwarding 0" >> $check_file
          if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
            echo "\t/usr/sbin/ndd -set /dev/ip ip6_forward_src_routed 0" >> $check_file
            echo "\t/usr/sbin/ndd -set /dev/tcp tcp_rev_src_routes 0" >> $check_file
            echo "\t/usr/sbin/ndd -set /dev/ip ip6_forwarding 0" >> $check_file
          fi
          echo "\t/usr/sbin/ndd -set /dev/ip ip_forward_directed_broadcasts 0" >> $check_file
          echo "\t/usr/sbin/ndd -set /dev/tcp tcp_conn_req_max_q0 4096" >> $check_file
          echo "\t/usr/sbin/ndd -set /dev/tcp tcp_conn_req_max_q 1024" >> $check_file
          echo "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_timestamp 0" >> $check_file
          echo "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_timestamp_broadcast 0" >> $check_file
          echo "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_address_mask_broadcast 0" >> $check_file
          echo "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_echo_multicast 0" >> $check_file
          if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
            echo "\t/usr/sbin/ndd -set /dev/ip ip6_respond_to_echo_multicast 0" >> $check_file
          fi
          echo "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_echo_broadcast 0" >> $check_file
          echo "\t/usr/sbin/ndd -set /dev/arp arp_cleanup_interval 60000" >> $check_file
          echo "\t/usr/sbin/ndd -set /dev/ip ip_ire_arp_interval 60000" >> $check_file
          echo "\t/usr/sbin/ndd -set /dev/ip ip_ignore_redirect 1" >> $check_file
          if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
            echo "\t/usr/sbin/ndd -set /dev/ip ip6_ignore_redirect 1" >> $check_file
          fi
          echo "\t/usr/sbin/ndd -set /dev/tcp tcp_extra_priv_ports_add 6112" >> $check_file
          echo "\t/usr/sbin/ndd -set /dev/ip ip_strict_dst_multihoming 1" >> $check_file
          if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
            echo "\t/usr/sbin/ndd -set /dev/ip ip6_strict_dst_multihoming 1" >> $check_file
          fi
          echo "\t/usr/sbin/ndd -set /dev/ip ip_send_redirects 0" >> $check_file
          if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
            echo "\t/usr/sbin/ndd -set /dev/ip ip6_send_redirects 0" >> $check_file
          fi
          echo "esac" >> $check_file
          echo "exit 0" >> $check_file
          chmod 750 $check_file
          if [ ! -f "$rcd_file" ]; then
            ln -s $check_file $rcd_file
          fi
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          funct_verbose_message "" fix
          if [ ! -f "$check_file" ]; then
            funct_verbose_message "Create an init script $check_file containing the following:"
            funct_verbose_message "#!/sbin/sh" fix
            funct_verbose_message "case \"\$1\" in" fix
            funct_verbose_message "start)" fix
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip_forward_src_routed 0" fix
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip_forwarding 0" fix
            if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
              funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip6_forward_src_routed 0" fix
              funct_verbose_message "\t/usr/sbin/ndd -set /dev/tcp tcp_rev_src_routes 0" fix
              funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip6_forwarding 0" fix
            fi
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip_forward_directed_broadcasts 0" fix
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/tcp tcp_conn_req_max_q0 4096" fix
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/tcp tcp_conn_req_max_q 1024" fix
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_timestamp 0" fix
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_timestamp_broadcast 0" fix
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_address_mask_broadcast 0" fix
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_echo_multicast 0" fix
            if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
              funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip6_respond_to_echo_multicast 0" fix
            fi
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_echo_broadcast 0" fix
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/arp arp_cleanup_interval 60000" fix
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip_ire_arp_interval 60000" fix
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip_ignore_redirect 1" fix
            if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
              funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip6_ignore_redirect 1" fix
            fi
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/tcp tcp_extra_priv_ports_add 6112" fix
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip_strict_dst_multihoming 1" fix
            if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
              funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip6_strict_dst_multihoming 1" fix
            fi
            funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip_send_redirects 0" fix
            if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
              funct_verbose_message "\t/usr/sbin/ndd -set /dev/ip ip6_send_redirects 0" fix
            fi
            funct_verbose_message "esac" fix
            funct_verbose_message "exit 0" fix
            funct_verbose_message "" fix
            funct_verbose_message "Then run the following command(s)" fix
            funct_verbose_message "chmod 750 $check_file" fix
            if [ ! -f "$rcd_file" ]; then
              funct_verbose_message "ln -s $check_file $rcd_file" fix
            fi
          fi
        fi
      fi
    fi
  fi
}
