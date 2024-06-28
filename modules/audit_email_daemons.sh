#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_email_daemons
#
# Check email daemons
#
# Refer to Section(s) 3.12   Page(s) 67    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.2.11 Page(s) 111   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 3.12   Page(s) 79-80 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 6.11   Page(s) 60    CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.2.11 Page(s) 111   CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_email_daemons () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Mail Daemons" "check"
    for service_name in cyrus imapd qpopper dovecot; do
      check_linux_service "$service_name" "off"
      check_linux_package "uninstall"     "$service_name"
    done
  fi
}
