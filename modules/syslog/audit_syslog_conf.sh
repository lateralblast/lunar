#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_syslog_conf
#
# Check syslog confg
#
# Refer to Section(s) 3.4     Page(s) 10    CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 5.1.1   Page(s) 104-5 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.11.13 Page(s) 39-40 CIS ESX Server 4 Benchmark v1.1.0
#
# Refer to http://kb.vmware.com/kb/1033696
# Refer to http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.security.doc/GUID-9F67DB52-F469-451F-B6C8-DAE8D95976E7.html
#.

audit_syslog_conf () {
  print_function "audit_syslog_conf"
  string="Syslog Configuration"
  check_message "${string}"
  if [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ] || [ "${os_name}" = "VMkernel" ]; then
    if [ "${os_name}" = "Linux" ]; then
      check_file="/etc/syslog.conf"
      if [ -f "/etc/rsyslog.conf" ]; then
        systemd_check=$(command -v systemctl 2> /dev/null )
        if [ -n "$systemd_check" ]; then
          command="sudo systemctl | grep rsyslog | grep active | awk '{print \$1}'"
          command_message "${command}"
          rsyslog_check=$( eval "${command}" )
          if [ "$rsyslog_check" = "rsyslog.service" ]; then
            if [ -f "/etc/rsyslog.d/90-cis.conf" ]; then
              check_file="/etc/rsyslog.d/90-cis.conf"
            else
              check_file="/etc/rsyslog.conf"
            fi
          fi
        fi
      fi
      check_file_value "is" "${check_file}" "authpriv.*" "tab" "/var/log/secure"     "hash"
      check_file_value "is" "${check_file}" "auth.*"     "tab" "/var/log/messages"   "hash"
      check_file_value "is" "${check_file}" "daemon.*"   "tab" "/var/log/daemon.log" "hash"
      check_file_value "is" "${check_file}" "syslog.*"   "tab" "/var/log/syslog"     "hash"
      check_file_value "is" "${check_file}" "lpr,news,uucp,local0,local1,local2,local3,local4,local5,local6.*" "tab" "/var/log/unused.log" "hash"
    fi
    if [ "${os_name}" = "FreeBSD" ]; then
      check_file_value "is" "/etc/rc.conf" "syslogd_flags" "eq" "-s" "hash"
    fi
    if [ "${os_name}" = "VMkernel" ]; then
      log_file="sysloglogdir"
      backup_file="${work_dir}/${log_file}"
      command="esxcli system syslog config get | grep 'Local Log Output:' | awk '{print \$4}'"
      command_message "${command}"
      current_value=$( eval ${command} )
      if [ "${audit_mode}" != "2" ]; then
        if [ "${current_value}" = "/scratch/log" ]; then
          if [ "${audit_mode}" = "0" ]; then
            if [ "${syslog_logdir}" != "" ]; then
              echo "${current_value}" > "${backup_file}"
              verbose_message "Setting:   Syslog log directory to a persistent datastore"
              esxcli system syslog config set --logdir="${syslog_logdir}"
            fi
          fi
          if [ "${audit_mode}" = "1" ]; then
            increment_insecure "Syslog log directory is not persistent"
            if [ "${syslog_logdir}" != "" ]; then
              verbose_message "esxcli system syslog config set --logdir=${syslog_logdir}" "fix"
            fi
          fi
        else
          if [ "${audit_mode}" = "1" ]; then
            increment_secure "Syslog log directory is on a persistent datastore"
          fi
        fi
      else
        restore_file="${restore_dir}/${log_file}"
        if [ -f "${restore_file}" ]; then
          previous_value=$( cat "${restore_file}" )
          if [ "${previous_value}" != "${current_value}" ]; then
            verbose_message "Restoring: Syslog log directory to ${previous_value}"
            command="esxcli system syslog config set --logdir=\"${previous_value}\""
            command_message "${command}"
            eval "${command}"
          fi
        fi
      fi
      log_file="syslogremotehost"
      backup_file="${work_dir}/${log_file}"
      command="esxcli system syslog config get | grep Remote | awk '{print \$3}'"
      command_message "${command}"
      current_value=$( eval "${command}" )
      if [ "${audit_mode}" != "2" ]; then
        if [ "${current_value}" = "<none>" ]; then
          if [ "${audit_mode}" = "0" ]; then
            if [ "${syslog_server}" != "" ]; then
              echo "${current_value}" > "${backup_file}"
              command="esxcli system syslog config set --loghost=\"${syslog_server}\""
              command_message "${command}"
              eval "${command}"
            fi
          fi
          if [ "${audit_mode}" = "1" ]; then
            increment_insecure "Syslog remote host is not enabled"
            if [ "${syslog_server}" = "" ]; then
              verbose_message "esxcli system syslog config set --loghost=XXX.XXX.XXX.XXX" "fix"
            else
              verbose_message "esxcli system syslog config set --loghost=${syslog_server}"  "fix"
            fi
          fi
        else
          if [ "${audit_mode}" = "1" ]; then
            increment_secure "Syslog remote host is enabled"
          fi
        fi
      else
        restore_file="${restore_dir}/${log_file}"
        if [ -f "${restore_file}" ]; then
          previous_value=$( cat "${restore_file}" )
          if [ "${previous_value}" != "${current_value}" ]; then
            verbose_message "Restoring: Syslog loghost to \"${previous_value}\""
            command="esxcli system syslog config set --loghost=\"${previous_value}\""
            command_message "${command}"
            eval "${command}"
          fi
        fi
      fi
    fi
  else
    na_message "${string}"
  fi
}
