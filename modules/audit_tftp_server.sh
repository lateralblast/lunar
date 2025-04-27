#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_tftp_server
#
# Turn off tftp
#
# Refer to Section(s) 2.1.8  Page(s) 52   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.8  Page(s) 60   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 2.2.20 Page(s) 121  CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 5.1.8  Page(s) 45   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.9    Page(s) 58-9 CIS SLES 11 Benchmark v1.0.0
#.

audit_tftp_server () {
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    verbose_message "TFTP Server Daemon" "check"
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
        check_file_perms    "/tftpboot"                      "0744" "root" "root"
        check_file_perms    "/etc/netboot"                   "0744" "root" "root"
        check_sunos_service "svc:/network/tftp/udp6:default" "disabled"
        check_sunos_service "svc:/network/tftp/udp4:default" "disabled"
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_linux_service "tftp"          "off"
      check_file_perms    "/tftpboot"     "0744" "root" "root"
      check_file_perms    "/var/tftpboot" "0744" "root" "root"
      if [ "${os_vendor}" = "CentOS" ] || [ "${os_vendor}" = "Red" ] || [ "${os_vendor}" = "Amazon" ]; then
        check_linux_service "tftp.socket" "off"
        check_linux_package "uninstall"   "tftp-server"
      fi
    fi
  fi
}
