#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_avahi_conf
#
# Check Avahi Configuration
# 
# Refer to Section(s) 3.1.3-6 Page(s) 68-72 CIS RHEL 5 Benchmark v2.1.0
#.

audit_avahi_conf () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message  "Multicast DNS Server" "check"
    check_file_value "is" "/etc/avahi/avahi-daemon.conf" "disable-user-service-publishing" "eq" "yes" "hash" "after" "\[publish\]"
    check_file_value "is" "/etc/avahi/avahi-daemon.conf" "disable-publishing"              "eq" "yes" "hash" "after" "\[publish\]"
    check_file_value "is" "/etc/avahi/avahi-daemon.conf" "publish-address"                 "eq" "no"  "hash" "after" "\[publish\]"
    check_file_value "is" "/etc/avahi/avahi-daemon.conf" "publish-binfo"                   "eq" "no"  "hash" "after" "\[publish\]"
    check_file_value "is" "/etc/avahi/avahi-daemon.conf" "publish-workstation"             "eq" "no"  "hash" "after" "\[publish\]"
    check_file_value "is" "/etc/avahi/avahi-daemon.conf" "publish-domain"                  "eq" "no"  "hash" "after" "\[publish\]"
    check_file_value "is" "/etc/avahi/avahi-daemon.conf" "disallow-other-stacks"           "eq" "yes" "hash" "after" "\[server\]"
    check_file_value "is" "/etc/avahi/avahi-daemon.conf" "check-response-ttl"              "eq" "yes" "hash" "after" "\[server\]"
  fi
}
