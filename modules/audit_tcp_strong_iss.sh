# audit_tcp_strong_iss
#
# Strong TCP Sequence Number Generation
#
# Checks for the following values in /etc/default/inetinit:
#
# TCP_STRONG_ISS=2
#
# The variable TCP_STRONG_ISS sets the mechanism for generating the order of
# TCP packets. If an attacker can predict the next sequence number, it is
# possible to inject fraudulent packets into the data stream to hijack the
# session. Solaris supports three sequence number methods:
#
# 0 = Old-fashioned sequential initial sequence number generation.
# 1 = Improved sequential generation, with random variance in increment.
# 2 = RFC 1948 sequence number generation, unique-per-connection-ID.
#
# The RFC 1948 method is widely accepted as the strongest mechanism for TCP
# packet generation. This makes remote session hijacking attacks more difficult,
# as well as any other network-based attack that relies on predicting TCP
# sequence number information. It is theoretically possible that there may be a
# small performance hit in connection setup time when this setting is used, but
# there are no benchmarks that establish this.
#
# Refer to Section(s) 3.3 Page(s) 27-8 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 3.4 Page(s) 63-4 CIS Solaris 10 Benchmark v5.1.0
#.

audit_tcp_strong_iss () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "TCP Sequence Number Generation"
    check_file="/etc/default/inetinit"
    funct_file_value $check_file TCP_STRONG_ISS eq 2 hash
    if [ "$os_version" != "11" ]; then
      audit_ndd_value /dev/tcp tcp_strong_iss 2
    fi
    if [ "$os_version" = "11" ]; then
      audit_ipadm_value _strong_iss tcp 2
    fi
  fi
}
