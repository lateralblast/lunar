#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_iptables
#
# Turn on iptables
#
# Refer to Section(s) 5.7-8   Page(s) 114-8  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 4.7-8   Page(s) 101-3  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 4.7-8   Page(s) 92-3   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 3.6.1   Page(s) 153-4  CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 3.6.1   Page(s) 139-40 CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 3.6.1-3 Page(s) 149-52 CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_iptables () {
  print_function "audit_iptables"
  string="IP Tables"
  check_message  "${string}"
  if [ "${os_name}" = "Linux" ]; then
    check_linux_package "install"   "iptables"
    check_linux_service "iptables"  "on"
    check_linux_service "ip6tables" "on"
    if [ "${audit_mode}" != 2 ]; then
      iptables_check=$( command -v iptables 2> /dev/null )
      if [ "${iptables_check}" ]; then
        if [ "${my_id}" != "0" ] && [ "${use_sudo}" != "1" ]; then
          notice_message "Requires root or sudo to check loopback rules"
          return
        fi
        command="iptables -L INPUT -v -n | grep \"127.0.0.0\" | grep \"0.0.0.0\" | grep DROP | uniq | wc -l | sed \"s/ //g\""
        if [ "${my_id}" != "0" ]; then
          command="sudo ${command}"
        fi
        command_message "${command}"
        rules_check=$( eval "${command}" )
        case "${rules_check}" in
          ''|*[!0-9]*)
            notice_message "Could not read loopback firewall rules"
            ;;
          0)
            inc_insecure "All other devices allow trafic to the loopback network"
            ;;
          *)
            inc_secure   "All other devices deny trafic to the loopback network"
            ;;
        esac
      fi
    fi
  else
    na_message "${string}"
  fi
}
