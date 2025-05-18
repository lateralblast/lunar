#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ufw
#
# Chec UFW is enabled
#
# Refer to Section(s) 3.5.1.1-3 Page(s) 216-20 CIS Ubuntu 22.04 Benchmark v1.0.0
# Refer to Section(s) 4.2.1-7   Page(s) 447-56 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_ufw () {
  print_module "audit_ufw"
  if [ "${os_name}" = "Linux" ] && [ "${os_vendor}" = "Ubuntu" ]; then
    verbose_message     "UFW"       "check"
    check_linux_package "install"   "ufw"
    check_linux_service "ufw"       "on"
    check_file_value    "is"        "/etc/ufw/ufw.conf"   "LOGLEVEL" "eg" "high" "hash"
    check_linux_package "uninstall" "iptables-persistent"
    #check_ufw_rule      ""
  fi
}