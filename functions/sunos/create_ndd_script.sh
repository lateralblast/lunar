#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154
# shellcheck disable=SC2129

# create_nddscript
#
# Creates an ndd boot script for Solaris
#
#.

create_nddscript () {
  print_function "create_nddscript"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" != "11" ]; then
      verbose_message "Kernel ndd Parameters" "check"
      check_file="/etc/init.d/ndd-netconfig"
      rcd_file="/etc/rc2.d/S99ndd-netconfig"
      if [ "${audit_mode}" = 0 ]; then
        if [ ! -f "${check_file}" ]; then
          echo "Creating:  Init script \"${check_file}\""
          printf "#!/sbin/sh"       > "${check_file}"
          printf "case \"\$1\" in"  >> "${check_file}"
          printf "start)"           >> "${check_file}"
          printf "\t/usr/sbin/ndd -set /dev/ip ip_forward_src_routed 0"                 >> "${check_file}"
          printf "\t/usr/sbin/ndd -set /dev/ip ip_forwarding 0"                         >> "${check_file}"
          if [ "${os_version}" = "8" ] || [ "${os_version}" = "9" ] || [ "${os_version}" = "10" ]; then
            printf "\t/usr/sbin/ndd -set /dev/ip ip6_forward_src_routed 0"              >> "${check_file}"
            printf "\t/usr/sbin/ndd -set /dev/tcp tcp_rev_src_routes 0"                 >> "${check_file}"
            printf "\t/usr/sbin/ndd -set /dev/ip ip6_forwarding 0"                      >> "${check_file}"
          fi
          printf "\t/usr/sbin/ndd -set /dev/ip ip_forward_directed_broadcasts 0"        >> "${check_file}"
          printf "\t/usr/sbin/ndd -set /dev/tcp tcp_conn_req_max_q0 4096"               >> "${check_file}"
          printf "\t/usr/sbin/ndd -set /dev/tcp tcp_conn_req_max_q 1024"                >> "${check_file}"
          printf "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_timestamp 0"               >> "${check_file}"
          printf "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_timestamp_broadcast 0"     >> "${check_file}"
          printf "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_address_mask_broadcast 0"  >> "${check_file}"
          printf "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_echo_multicast 0"          >> "${check_file}"
          if [ "${os_version}" = "8" ] || [ "${os_version}" = "9" ] || [ "${os_version}" = "10" ]; then
            printf "\t/usr/sbin/ndd -set /dev/ip ip6_respond_to_echo_multicast 0"       >> "${check_file}"
          fi
          printf "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_echo_broadcast 0"          >> "${check_file}"
          printf "\t/usr/sbin/ndd -set /dev/arp arp_cleanup_interval 60000"             >> "${check_file}"
          printf "\t/usr/sbin/ndd -set /dev/ip ip_ire_arp_interval 60000"               >> "${check_file}"
          printf "\t/usr/sbin/ndd -set /dev/ip ip_ignore_redirect 1"                    >> "${check_file}"
          if [ "${os_version}" = "8" ] || [ "${os_version}" = "9" ] || [ "${os_version}" = "10" ]; then
            printf "\t/usr/sbin/ndd -set /dev/ip ip6_ignore_redirect 1"                 >> "${check_file}"
          fi
          printf "\t/usr/sbin/ndd -set /dev/tcp tcp_extra_priv_ports_add 6112"          >> "${check_file}"
          printf "\t/usr/sbin/ndd -set /dev/ip ip_strict_dst_multihoming 1"             >> "${check_file}"
          if [ "${os_version}" = "8" ] || [ "${os_version}" = "9" ] || [ "${os_version}" = "10" ]; then
            printf "\t/usr/sbin/ndd -set /dev/ip ip6_strict_dst_multihoming 1"          >> ${check_file}
          fi
          printf "\t/usr/sbin/ndd -set /dev/ip ip_send_redirects 0"                     >> "${check_file}"
          if [ "${os_version}" = "8" ] || [ "${os_version}" = "9" ] || [ "${os_version}" = "10" ]; then
            printf "\t/usr/sbin/ndd -set /dev/ip ip6_send_redirects 0"                  >> "${check_file}"
          fi
          printf "esac"   >> ${check_file}
          printf "exit 0" >> ${check_file}
          chmod 750 ${check_file}
          if [ ! -f "${rcd_file}" ]; then
            ln -s "${check_file}" "${rcd_file}"
          fi
        fi
      else
        if [ "${audit_mode}" = 1 ]; then
          fix_message ""
          if [ ! -f "${check_file}" ]; then
            fix_message "Create an init script ${check_file} containing the following:"
            fix_message "#!/sbin/sh"
            fix_message "case \"\$1\" in"
            fix_message "start)"
            fix_message "\t/usr/sbin/ndd -set /dev/ip ip_forward_src_routed 0"
            fix_message "\t/usr/sbin/ndd -set /dev/ip ip_forwarding 0"
            if [ "${os_version}" = "8" ] || [ "${os_version}" = "9" ] || [ "${os_version}" = "10" ]; then
              fix_message "\t/usr/sbin/ndd -set /dev/ip ip6_forward_src_routed 0"
              fix_message "\t/usr/sbin/ndd -set /dev/tcp tcp_rev_src_routes 0"
              fix_message "\t/usr/sbin/ndd -set /dev/ip ip6_forwarding 0"
            fi
            fix_message "\t/usr/sbin/ndd -set /dev/ip ip_forward_directed_broadcasts 0"
            fix_message "\t/usr/sbin/ndd -set /dev/tcp tcp_conn_req_max_q0 4096"
            fix_message "\t/usr/sbin/ndd -set /dev/tcp tcp_conn_req_max_q 1024"
            fix_message "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_timestamp 0"
            fix_message "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_timestamp_broadcast 0"
            fix_message "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_address_mask_broadcast 0"
            fix_message "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_echo_multicast 0"
            if [ "${os_version}" = "8" ] || [ "${os_version}" = "9" ] || [ "${os_version}" = "10" ]; then
              fix_message "\t/usr/sbin/ndd -set /dev/ip ip6_respond_to_echo_multicast 0"
            fi
            fix_message "\t/usr/sbin/ndd -set /dev/ip ip_respond_to_echo_broadcast 0"
            fix_message "\t/usr/sbin/ndd -set /dev/arp arp_cleanup_interval 60000"
            fix_message "\t/usr/sbin/ndd -set /dev/ip ip_ire_arp_interval 60000"
            fix_message "\t/usr/sbin/ndd -set /dev/ip ip_ignore_redirect 1"
            if [ "${os_version}" = "8" ] || [ "${os_version}" = "9" ] || [ "${os_version}" = "10" ]; then
              fix_message "\t/usr/sbin/ndd -set /dev/ip ip6_ignore_redirect 1"
            fi
            fix_message "\t/usr/sbin/ndd -set /dev/tcp tcp_extra_priv_ports_add 6112"
            fix_message "\t/usr/sbin/ndd -set /dev/ip ip_strict_dst_multihoming 1"
            if [ "${os_version}" = "8" ] || [ "${os_version}" = "9" ] || [ "${os_version}" = "10" ]; then
              fix_message "\t/usr/sbin/ndd -set /dev/ip ip6_strict_dst_multihoming 1"
            fi
            fix_message "\t/usr/sbin/ndd -set /dev/ip ip_send_redirects 0"
            if [ "${os_version}" = "8" ] || [ "${os_version}" = "9" ] || [ "${os_version}" = "10" ]; then
              fix_message "\t/usr/sbin/ndd -set /dev/ip ip6_send_redirects 0"
            fi
            fix_message "esac"
            fix_message "exit 0"
            fix_message ""
            fix_message "Then run the following command(s)"
            fix_message "chmod 750 ${check_file}"
            if [ ! -f "${rcd_file}" ]; then
              fix_message "ln -s ${check_file} ${rcd_file}"
            fi
          fi
        fi
      fi
    fi
  fi
}
