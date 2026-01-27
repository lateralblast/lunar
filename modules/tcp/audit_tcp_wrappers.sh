#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2046
# shellcheck disable=SC2154

# audit_tcp_wrappers
#
# Check TCP wrappers
#
# Refer to Section(s) 5.5.1-5  Page(s) 110-114 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 4.5.1-5  Page(s) 95-8    CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 4.5.1-5  Page(s) 86-9    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 3.4.1-5  Page(s) 143-8   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 7.4.1-5  Page(s) 77-80   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.3      Page(s) 3-4     CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.10.1-4 Page(s) 188-192 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.11     Page(s) 22-3    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 2.4      Page(s) 36-7    CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 3.4.1-5  Page(s) 1verbose_message "-4   CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 3.4.1-5  Page(s) 139-43  CIS Ubuntu 16.04 Benchmark v2.0.0
#.

audit_tcp_wrappers () {
  print_function "audit_tcp_wrappers"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ] || [ "${os_name}" = "Darwin" ] || [ "${os_name}" = "AIX" ]; then
    verbose_message "TCP Wrappers" "check"
    if [ "${os_name}" = "AIX" ]; then
      package_name="netsec.options.tcpwrapper.base"
      check_lslpp "${package_name}"
      if [ "${audit_mode}" != 2 ]; then
        if [ "${lslpp_check}" != "${package_name}" ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "TCP Wrappers not installed"
            verbose_message    "TCP Wrappers not installed" "fix"
            verbose_message    "Install TCP Wrappers"       "fix"
          fi
        else
          increment_secure "TCP Wrappers installed"
        fi
      fi
    fi
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
        audit_rpc_bind
        for service_name in $( inetadm | awk '{print $3}' | grep "^svc" ); do
          check_command_value "inetadm" "tcp_wrappers" "TRUE" "${service_name}"
        done
      fi
    fi
    if [ "${os_name}" = "FreeBSD" ]; then
      check_file_value "is" "/etc/rc.conf" "inetd_enable" "eq" "YES"       "hash"
      check_file_value "is" "/etc/rc.conf" "inetd_flags"  "eq" "-Wwl -C60" "hash"
    fi
    check_file_value "is" "/etc/hosts.deny"  "ALL" "colon" " ALL"       "hash"
    check_file_value "is" "/etc/hosts.allow" "ALL" "colon" " localhost" "hash"
    check_file_value "is" "/etc/hosts.allow" "ALL" "colon" " 127.0.0.1" "hash"
    ip_list=$( who | cut -d"(" -f2 | cut -d")" -f1 | sort -u )
    for ip_address in ${ip_list}; do
      check_file_value "is" "/etc/hosts.allow" "ALL" "colon" " ${ip_address}" "hash"
    done
    if [ ! -f "${check_file}" ]; then
      check=$( command -v ifconfig 2> /dev/null )
      if [ "${check}" ]; then
        ip_list=$( ifconfig -a | grep "inet [0-9]" | grep -v " 127." | awk '{print $2}' | cut -f2 -d":" )
        for ip_address in ${ip_list}; do
          netmask=$( ifconfig -a | grep "${ip_address}" | awk '{print $3}' | cut -f2 -d":" )
          for daemon in ${tcpd_allow}; do
            check_file_value "is" "${check_file}" "${daemon}" "colon" " ${ip_address}/${netmask}" "hash"
          done
        done
      else
        check=$( command -v ip 2> /dev/null )
        if [ "${check}" ]; then
          ip_values=$( ip addr | grep 'inet [0-9]' | grep -v ' 127.' | awk '{print $2}' )
          for ip_value in $ip_values; do
            set -- $( echo "$ip_value" | awk -F"/" '{print $1" "$2 }' )
            ip_address="${1}"
            cidr="${2}"
            netmask=$( cidr_to_mask "$cidr" )
            for daemon in ${tcpd_allow}; do
              check_file_value "is" "${check_file}" "${daemon}" "colon" " ${ip_address}/${netmask}" "hash"
            done
          done
        fi
      fi
    fi
    if [ "${os_name}" = "AIX" ]; then
      group_name="system"
    else
      group_name="root"
    fi
    check_file_perms "/etc/hosts.deny"  "0644" "root" "${group_name}"
    check_file_perms "/etc/hosts.allow" "0644" "root" "${group_name}"
    if [ "${os_name}" = "Linux" ]; then
      if [ "${os_vendor}" = "Red" ] || [ "${os_vendor}" = "SuSE" ] || [ "${os_vendor}" = "CentOS" ] || [ "${os_vendor}" = "Amazon" ] ; then
        check_linux_package "install" "tcp_wrappers"
      else
        check_linux_package "install" "tcpd"
      fi
    fi
  fi
}
