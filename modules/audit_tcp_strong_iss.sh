# audit_tcp_strong_iss
#
# Strong TCP Sequence Number Generation
#
# Checks for the following values in /etc/default/inetinit:
#
# TCP_STRONG_ISS=2
#
# 0 = Old-fashioned sequential initial sequence number generation.
# 1 = Improved sequential generation, with random variance in increment.
# 2 = RFC 1948 sequence number generation, unique-per-connection-ID.
#
# Refer to Section(s) 3.3 Page(s) 27-8 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 3.4 Page(s) 63-4 CIS Solaris 10 Benchmark v5.1.0
#.

audit_tcp_strong_iss () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "TCP Sequence Number Generation"
    check_file="/etc/default/inetinit"
    check_file_value is $check_file TCP_STRONG_ISS eq 2 hash
    if [ "$os_version" != "11" ]; then
      audit_ndd_value /dev/tcp tcp_strong_iss 2
    fi
    if [ "$os_version" = "11" ]; then
      audit_ipadm_value _strong_iss tcp 2
    fi
  fi
}
