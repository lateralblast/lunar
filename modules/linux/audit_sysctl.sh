#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_sysctl
#
# Check sysctl settings
#
# Refer to Section(s) 5.1-5.2.8,5.4.1,2             Page(s) 98-107                  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 4.1.1-2,4.2.1-8,4.4.1         Page(s) 82-94                   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 4.1.1-2,4.2.1-8,4.4.1.1       Page(s) 73-81,83-4              CIS RHEL 5 Benchmark v2.1.
# Refer to Section(s) 1.4.1,1.5.3,3.1.1-8,3.3.1-3   Page(s) 57,65,129-142           CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 7.1.1-8,7.3.1-2               Page(s) 65-76                   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.5.3,3.3.1-2,3.2.1-8,3.3.1-3 Page(s) 60-1,125-6,127-35,136-8 CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 3.3.1-11                      Page(s) 386-436                 CIS Ubuntu 24.04 Benchmark v1.0.0
# Refer to Section(s) 1.1.2,1.5.1,3,3.1.1-8,3.3.1-3 Page(s) 24-6,53,57,116-29       CIS Amazon Linux Benchmark v2.0.0
#.

audit_sysctl () {
  print_function "audit_sysctl"
  string="Sysctl Configuration"
  check_message "${string}"
  if [ "${os_name}" = "Linux" ]; then
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.conf.default.secure_redirects"     "eq"   "0"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.conf.all.secure_redirects"         "eq"   "0"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.icmp_echo_ignore_broadcasts"       "eq"   "1"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.conf.all.accept_redirects"         "eq"   "0"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.conf.default.accept_redirects"     "eq"   "0"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.tcp_syncookies"                    "eq"   "1"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.tcp_max_syn_backlog"               "eq"   "4096" "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.conf.all.rp_filter"                "eq"   "1"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.conf.default.rp_filter"            "eq"   "1"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.conf.all.accept_source_route"      "eq"   "0"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.conf.default.accept_source_route"  "eq"   "0"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.tcp_max_orphans"                   "eq"   "256"  "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.conf.all.log_martians"             "eq"   "1"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.ip_forward"                        "eq"   "0"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.conf.all.send_redirects"           "eq"   "0"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.conf.default.send_redirects"       "eq"   "0"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv4.icmp_ignore_bogus_error_responses" "eq"   "1"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv6.conf.default.accept_redirects"     "eq"   "0"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv6.conf.all.accept_ra"                "eq"   "0"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv6.conf.default.accept_ra"            "eq"   "0"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "net.ipv6.route.flush"                       "eq"   "1"    "hash"
    check_file_value  "is" "/etc/sysctl.conf"     "kernel.randomize_va_space"                  "eq"   "2"    "hash"
    check_append_file "/etc/security/limits.conf" "* hard core 0"                              "hash"
    check_file_perms  "/etc/sysctl.conf"          "0600"                                       "root" "root"
  else
    na_message "${string}"
  fi
}
