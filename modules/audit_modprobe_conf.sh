# audit_modprobe_conf
#
# Check entries are in place so kernel modules can't be force loaded.
# Some modules may getting unintentionally loaded that could reduce system
# security.
# If the protocol is not required, it is recommended that the drivers not be
# installed to reduce the potential attack surface.
#
# Disable DCCP:
#
# The Datagram Congestion Control Protocol (DCCP) is a transport layer protocol
# that supports streaming media and telephony. DCCP provides a way to gain
# access to congestion control, without having to do it at the application
# layer, but does not provide in- sequence delivery.
#
# Disable SCTP:
#
# The Stream Control Transmission Protocol (SCTP) is a transport layer protocol
# used to support message oriented communication, with several streams of
# messages in one connection. It serves a similar function as TCP and UDP,
# incorporating features of both. It is message-oriented like UDP, and ensures
# reliable in-sequence transport of messages with congestion control like TCP.
#
# Disable RDS:
#
# The Reliable Datagram Sockets (RDS) protocol is a transport layer protocol
# designed to provide low-latency, high-bandwidth communications between
# cluster nodes. It was developed by the Oracle Corporation.
#
# Disable TIPC:
#
# The Transparent Inter-Process Communication (TIPC) protocol is designed to
# provide communication between cluster nodes.
#
# Refer to Section(s) 1.18-24,5.6.1-4 Page(s) 26-30,114-6 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.18-24,4.6.1-4 Page(s) 27-32,90-2 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 2.18-24, Page(s) 26-30 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.1.18-24,4.6.1-2 Page(s) 28-33,98-100 CIS Red Hat Linux 5 Benchmark v2.1.0
#.

audit_modprobe_conf () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Modprobe Configuration"
    check_file="/etc/modprobe.conf"
    funct_append_file $check_file "install tipc /bin/true"
    funct_append_file $check_file "install rds /bin/true"
    funct_append_file $check_file "install sctp /bin/true"
    funct_append_file $check_file "install dccp /bin/true"
    funct_append_file $check_file "install udf /bin/true"
    funct_append_file $check_file "install squashfs /bin/true"
    funct_append_file $check_file "install hfs /bin/true"
    funct_append_file $check_file "install hfsplus /bin/true"
    funct_append_file $check_file "install jffs2 /bin/true"
    funct_append_file $check_file "install freevxfs /bin/true"
    funct_append_file $check_file "install cramfs /bin/true"
  fi
}
