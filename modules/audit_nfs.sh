#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_nfs
#
# Check NFS
#
# Refer to Section(s) 3.8    Page(s) 64-5  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.8    Page(s) 77    CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.8    Page(s) 67-8  CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.7  Page(s) 107   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 6.7    Page(s) 57-8  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 3.7-11 Page(s) 11-3  CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.5  Page(s) 39    CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.2.7  Page(s) 99    CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.7  Page(s) 107   CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 4.6    Page(s) 105-6 CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 4.3    Page(s) 294-5 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_nfs () {
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ] || [ "${os_name}" = "AIX" ] || [ "${os_name}" = "Darwin" ]; then
    if [ "$nfsd_disable" = "yes" ]; then
      verbose_message "NFS Services" "check"
      if [ "${os_name}" = "AIX" ]; then
        check_itab "rcnfs" "off"
      fi
      if [ "${os_name}" = "Darwin" ]; then
        check_launchctl_service "com.apple.nfsd" "off"
      fi
      if [ "${os_name}" = "SunOS" ]; then
        if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
          for service_name in "svc:/network/nfs/mapid:default" \
            "svc:/network/nfs/status:default" "svc:/network/nfs/cbd:default" \
            "svc:/network/nfs/nlockmgr:default" "svc:/network/nfs/client:default" \
            "svc:/network/nfs/server:default"; do
            check_sunos_service "${service_name}" "disabled"
          done
        fi
        if [ "${os_version}" != "11" ]; then
          check_sunos_service "nfs.server" "disabled"
        fi
        check_file_value "is" "/etc/system" "nfssrv:nfs_portmon" "eq" "1" "star"
      fi
      if [ "${os_name}" = "Linux" ]; then
        for service_name in nfs nfslock rpc nfs-kerner-server rpcbind; do
          check_linux_service "${service_name}" "off"
        done
      fi
      if [ "${os_name}" = "FreeBSD" ]; then
        check_file_value "is" "/etc/rc.conf" "nfs_reserved_port_only"     "eq" "YES" "hash"
        check_file_value "is" "/etc/rc.conf" "weak_mountd_authentication" "eq" "NO"  "hash"
        check_file_value "is" "/etc/rc.conf" "rpc_lockd_enable"           "eq" "NO"  "hash"
        check_file_value "is" "/etc/rc.conf" "rpc_statd_enable"           "eq" "NO"  "hash"
        if [ "${os_version}" -lt 5 ]; then
          check_file_value "is" "/etc/rc.conf" "portmap_enable"       "eq" "NO" "hash"
          check_file_value "is" "/etc/rc.conf" "nfs_server_enable"    "eq" "NO" "hash"
          check_file_value "is" "/etc/rc.conf" "single_mountd_enable" "eq" "NO" "hash"
        else
          check_file_value "is" "/etc/rc.conf" "rpcbind_enable"       "eq" "NO" "hash"
          check_file_value "is" "/etc/rc.conf" "nfs_server_enable"    "eq" "NO" "hash"
          check_file_value "is" "/etc/rc.conf" "mountd_enable"        "eq" "NO" "hash"
        fi
      fi
    fi
  fi
}
