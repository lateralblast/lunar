# audit_avahi_conf
#
# The multicast Domain Name System (mDNS) is a zero configuration host name
# resolution service. It uses essentially the same programming interfaces,
# packet formats and operating semantics as the unicast Domain Name System
# (DNS) to resolve host names to IP addresses within small networks that do
# not include a local name server, but can also be used in conjunction with
# such servers.
# It is best to turn off mDNS in a server environment, but if it is used then
# the services advertised should be restricted.
#
# Refer to Section(s) 3.1.3-6 Page(s) 68-72 CIS Red Hat Enterprise Linux 5 Benchmark v2.1.0
#.

audit_avahi_conf () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Multicast DNS Server"
    check_file="/etc/avahi/avahi-daemon.conf"
    funct_file_value $check_file disable-user-service-publishing eq yes hash after "\[publish\]"
    funct_file_value $check_file disable-publishing eq yes hash after "\[publish\]"
    funct_file_value $check_file publish-address eq no hash after "\[publish\]"
    funct_file_value $check_file publish-binfo eq no hash after "\[publish\]"
    funct_file_value $check_file publish-workstation eq no hash after "\[publish\]"
    funct_file_value $check_file publish-domain eq no hash after "\[publish\]"
    funct_file_value $check_file disallow-other-stacks eq yes hash after "\[server\]"
    funct_file_value $check_file check-response-ttl eq yes hash after "\[server\]"
  fi
}
