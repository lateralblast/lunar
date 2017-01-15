# audit_tcpsyn_cookie
#
#  TCP SYN Cookie Protection
#
# Refer to Section(s) 4.2.8 Page(s) 90-1 CIS Red Hat Enterprise Linux 5 Benchmark v2.1.0
# Refer to Section(s) 4.2.8 Page(s) 82-3 CIS Red Hat Enterprise Linux 6 Benchmark v1.2.0
#.

audit_tcp_syn_cookie () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "TCP SYN Cookie Protection"
    check_file="/etc/rc.d/local"
    funct_append_file $check_file "echo 1 > /proc/sys/net/ipv4/tcp_syncookies" hash
    funct_check_perms $check_file 0600 root root
  fi
}
