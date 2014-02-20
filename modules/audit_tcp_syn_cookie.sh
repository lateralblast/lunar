# audit_tcpsyn_cookie
#
#  TCP SYN Cookie Protection
#.

audit_tcp_syn_cookie () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "TCP SYN Cookie Protection"
    check_file="/etc/rc.d/local"
    funct_append_file $check_file "echo 1 > /proc/sys/net/ipv4/tcp_syncookies" hash
    funct_check_perms $check_file 0600 root root
  fi
}
