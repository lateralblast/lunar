#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ftp_server
#
# Turn off ftp server
#
# Refer to Section(s) 3.10  Page(s) 66    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.10  Page(s) 78-9  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.10  Page(s) 68-9  CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.9 Page(s) 109   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 2.2.9 Page(s) 101   CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.9 Page(s) 109   CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 2.1.6 Page(s) 242-4 CIS Ubuntu 24.04 Benchmark v1.0.0
# Refer to Section(s) 4.5   Page(s) 103-4 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_ftp_server () {
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "Darwin" ]; then
    verbose_message "FTP Daemon" "check"
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
        check_sunos_service "svc:/network/ftp:default" "disabled"
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_linux_service "vsftpd"    "off"
      check_linux_package "uninstall" "vsftpd"
    fi
    if [ "${os_name}" = "Darwin" ]; then
      check_launchctl "ftp" "off"
    fi
  fi
}
