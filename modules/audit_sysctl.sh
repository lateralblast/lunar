
# audit_sysctl
#
# Network tuning parameters for sysctl under Linux.
# Check and review to see which are suitable for you environment.
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
    funct_file_value $check_file net.ipv6.conf.default.accept_ra eq 0 hash
    # Randomise kernel memory placement
    funct_file_value $check_file kernel.randomize_va_space eq 1 hash
    # Configure kernel shield
    funct_file_value $check_file kernel.exec-shield eq 1 hash
    # Restrict core dumps
    funct_file_value $check_file fs.suid.dumpable eq 0 hash
    funct_append_file /etc/security/limits.conf "* hard core 0"
    # Check file permissions
    funct_check_perms $check_file 0600 root root
  fi
}
