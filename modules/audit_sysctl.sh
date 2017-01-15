# audit_sysctl
#
# Network tuning parameters for sysctl under Linux.
# Check and review to see which are suitable for you environment.
#
# Disable IP Forwarding:
#
# The net.ipv4.ip_forward flag is used to tell the server whether it can
# forward packets or not. If the server is not to be used as a router, set the
# flag to 0.
# Setting the flag to 0 ensures that a server with multiple interfaces
# (for example, a hard proxy), will never be able to forward packets, and
# therefore, never serve as a router.
#
# Disable Send Packet Redirects:
#
# ICMP Redirects are used to send routing information to other hosts.
# As a host itself does not act as a router (in a host only configuration),
# there is no need to send redirects.
# An attacker could use a compromised host to send invalid ICMP redirects to
# other router devices in an attempt to corrupt routing and have users access
# a system set up by the attacker as opposed to a valid system.
#
# Disable Source Routed Packet Acceptance:
#
# In networking, source routing allows a sender to partially or fully specify
# the route packets take through a network. In contrast, non-source routed
# packets travel a path determined by routers in the network. In some cases,
# systems may not be routable or reachable from some locations (e.g. private
# addresses vs. Internet routable), and so source routed packets would need to
# be used.
# Settingnet.ipv4.conf.all.accept_source_route and
# net.ipv4.conf.default.accept_source_route to 0 disables the system from
# accepting source routed packets. Assume this server was capable of routing
# packets to Internet routable addresses on one interface and private addresses
# on another interface. Assume that the private addresses were not routable to
# the Internet routable addresses and vice versa. Under normal routing
# circumstances, an attacker from the Internet routable addresses could not
# use the server as a way to reach the private address servers. If, however,
# source routed packets were allowed, they could be used to gain access to the
# private address systems as the route could be specified, rather than rely on
# routing protocols that did not allow this routing.
#
# Disable ICMP Redirect Acceptance:
#
# ICMP redirect messages are packets that convey routing information and tell
# your host (acting as a router) to send packets via an alternate path.
# It is a way of allowing an outside routing device to update your system
# routing tables. By settinganet.ipv4.conf.all.accept_redirects to 0, the
# system will not accept any ICMP redirect messages, and therefore, won't
# allow outsiders to update the system's routing tables.
#
# Disable Secure ICMP Redirect Acceptance:
#
# Secure ICMP redirects are the same as ICMP redirects, except they come from
# gateways listed on the default gateway list. It is assumed that these
# gateways are known to your system, and that they are likely to be secure.
# It is still possible for even known gateways to be compromised. Setting
# net.ipv4.conf.all.secure_redirects to 0 protects the system from routing
# table updates by possibly compromised known gateways.
#
# Log Suspicious Packets:
#
# When enabled, this feature logs packets with un-routable source addresses
# to the kernel log.
# Enabling this feature and logging these packets allows an administrator to
# investigate the possibility that an attacker is sending spoofed packets to
# their server.
#
# Enable Ignore Broadcast Requests;
#
# Setting net.ipv4.icmp_echo_ignore_broadcasts to 1 will cause the system to
# ignore all ICMP echo and timestamp requests to broadcast and multicast
# addresses.
# Accepting ICMP echo and timestamp requests with broadcast or multicast
# destinations for your network could be used to trick your host into starting
# (or participating) in a Smurf attack. A Smurf attack relies on an attacker
# sending large amounts of ICMP broadcast messages with a spoofed source
# address. All hosts receiving this message and responding would send
# echo-reply messages back to the spoofed address, which is probably not
# routable. If many hosts respond to the packets, the amount of traffic on
# the network could be significantly multiplied.
#
# Enable Bad Error Message Protection:
#
# Setting icmp_ignore_bogus_error_responses to 1 prevents the the kernel from
# logging bogus responses (RFC-1122 non-compliant) from broadcast reframes,
# keeping file systems from filling up with useless log messages.
# Some routers (and some attackers) will send responses that violate RFC-1122
# and attempt to fill up a log file system with many useless error messages.
#
# Enable RFC-recommended Source Route Validation:
#
# Setting net.ipv4.conf.all.rp_filter and net.ipv4.conf.default.rp_filter to 1
# forces the Linux kernel to utilize reverse path filtering on a received
# packet to determine if the packet was valid. Essentially, with reverse path
# filtering, if the return packet does not go out the same interface that the
# corresponding source packet came from, the packet is dropped (and logged if
# log_martians is set).
# Setting these flags is a good way to deter attackers from sending your server
# bogus packets that cannot be responded to. One instance where this feature
# breaks down is if asymmetrical routing is employed. This is would occur when
# using dynamic routing protocols (bgp, ospf, etc) on your system. If you are
# using asymmetrical routing on your server, you will not be able to enable
# this feature without breaking the routing.
#
# Enable TCP SYN Cookies:
#
# When tcp_syncookies is set, the kernel will handle TCP SYN packets normally
# until the half-open connection queue is full, at which time, the SYN cookie
# functionality kicks in. SYN cookies work by not using the SYN queue at all.
# Instead, the kernel simply replies to the SYN with a SYN|ACK, but will
# include a specially crafted TCP sequence number that encodes the source and
# destination IP address and port number and the time the packet was sent.
# A legitimate connection would send the ACK packet of the three way handshake
# with the specially crafted sequence number. This allows the server to verify
# that it has received a valid response to a SYN cookie and allow the
# connection, even though there is no corresponding SYN in the queue.
# Attackers use SYN flood attacks to perform a denial of service attacked on a
# server by sending many SYN packets without completing the three way handshake.
# This will quickly use up slots in the kernel's half-open connection queue and
# prevent legitimate connections from succeeding. SYN cookies allow the server
# to keep accepting valid connections, even if under a denial of service attack.
#
# Disable IPv6 Router Advertisements:
#
# This setting disables the systems ability to accept router advertisements.
# It is recommended that systems not accept router advertisements as they could
# be tricked into routing traffic to compromised machines. Setting hard routes
# within the system (usually a single default route to a trusted router)
# protects the system from bad routes.
#
# Disable IPv6 Redirect Acceptance:
#
# This setting prevents the system from accepting ICMP redirects.
# ICMP redirects tell the system about alternate routes for sending traffic.
# It is recommended that systems not accept ICMP redirects as they could be
# tricked into routing traffic to compromised machines. Setting hard routes
# within the system (usually a single default route to a trusted router)
# protects the system from bad routes.
#
# Refer to Section(s) 5.1-5.2.8,5.4.1,2             Page(s) 98-107            CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 4.1.1-2,4.2.1-8,4.4.1         Page(s) 82-94             CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 4.1.1-2,4.2.1-8,4.4.1.1       Page(s) 73-81,83-4        CIS Red Hat Linux 5 Benchmark v2.1.
# Refer to Section(s) 1.4.1,1.5.3,3.1.1-8,3.3.1-3   Page(s) 57,65,129-142     CIS Red Hat Linux 7 Benchmark v2.1.0
# Refer to Section(s) 7.1.1-8,7.3.1-2               Page(s) 65-76             CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.1.2,1.5.1,3,3.1.1-8,3.3.1-3 Page(s) 24-6,53,57,116-29 CIS Amazon Linux Benchmark v2.0.0
#.

audit_sysctl () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Sysctl Configuration"
    check_file="/etc/sysctl.conf"
    funct_file_value $check_file net.ipv4.conf.default.secure_redirects eq 0 hash
    funct_file_value $check_file net.ipv4.conf.all.secure_redirects eq 0 hash
    funct_file_value $check_file net.ipv4.icmp_echo_ignore_broadcasts eq 1 hash
    funct_file_value $check_file net.ipv4.conf.all.accept_redirects eq 0 hash
    funct_file_value $check_file net.ipv4.conf.default.accept_redirects eq 0 hash
    funct_file_value $check_file net.ipv4.tcp_syncookies eq 1 hash
    funct_file_value $check_file net.ipv4.tcp_max_syn_backlog eq 4096 hash
    funct_file_value $check_file net.ipv4.conf.all.rp_filter eq 1 hash
    funct_file_value $check_file net.ipv4.conf.default.rp_filter eq 1 hash
    funct_file_value $check_file net.ipv4.conf.all.accept_source_route eq 0 hash
    funct_file_value $check_file net.ipv4.conf.default.accept_source_route eq 0 hash
    # Disable these if machine used as a firewall or gateway
    funct_file_value $check_file net.ipv4.tcp_max_orphans eq 256 hash
    funct_file_value $check_file net.ipv4.conf.all.log_martians eq 1 hash
    funct_file_value $check_file net.ipv4.ip_forward eq 0 hash
    funct_file_value $check_file net.ipv4.conf.all.send_redirects eq 0 hash
    funct_file_value $check_file net.ipv4.conf.default.send_redirects eq 0 hash
    funct_file_value $check_file net.ipv4.icmp_ignore_bogus_error_responses eq 1 hash
    # IPv6 stuff
    funct_file_value $check_file net.ipv6.conf.default.accept_redirects eq 0 hash
    funct_file_value $check_file net.ipv6.conf.all.accept_ra eq 0 hash
    funct_file_value $check_file net.ipv6.conf.default.accept_ra eq 0 hash
    funct_file_value $check_file net.ipv6.route.flush eq 1 hash
    # Randomise kernel memory placement
    funct_file_value $check_file kernel.randomize_va_space eq 2 hash
    # Configure kernel shield
    funct_file_value $check_file kernel.exec-shield eq 1 hash
    # Restrict core dumps
    funct_file_value $check_file fs.suid.dumpable eq 0 hash
    funct_append_file /etc/security/limits.conf "* hard core 0"
    # Check file permissions
    funct_check_perms $check_file 0600 root root
  fi
}
