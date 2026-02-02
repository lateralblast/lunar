#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2063
# shellcheck disable=SC2154

# audit_syslog_server
#
# Check syslog server settings
#
# Refer to Section(s) 4.1.1-8           Page(s) 71-76   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 5.2.1-8           Page(s) 108-113 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 5.1.1-8           Page(s) 94-9    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 4.2.1.1-5         Page(s) 192-198 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 8.2.1-8           Page(s) 106-111 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 5.1               Page(s) 18      CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 4.2.1.1-5         Page(s) 176-82  CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 4.2.1.1-5         Page(s) 187-93  CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 4.2.1.1-4.2.2.7   Page(s) 556-92  CIS Ubuntu 22.04 Benchmark v1.0.0
# Refer to Section(s) 6.1.1.1.1-6.1.3.7 Page(s) 728-86  CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_syslog_server () {
  print_function "audit_syslog_server"
  if [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ]; then
    verbose_message "Syslog Daemon" "check"
    if [ "${os_name}" = "FreeBSD" ]; then
      if [ "${os_version}" -lt 5 ]; then
        check_file_value  "is" "/etc/syslog.conf" "daemon.debug" "tab"  "/var/log/daemon.log" "hash"
        check_file_exists "/var/log/daemon.log"   "file"         "yes"
        funct_file_perms  "/var/log/daemon.log"   "600"          "root" "${wheel_group}"
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      if [ "${os_vendor}" = "Ubuntu" ] && [ "${os_version}" -ge 22 ]; then
        check_linux_package "install" "systemd-journal-remote"
        if [ "${syslog_server}" != "" ]; then
          check_file_value "is" "/etc/systemd/journal-upload.conf"  "URL" "eq" "${syslog_server}" "hash"
        fi
        check_file_value    "is" "/etc/systemd/journal-upload.conf" "ServerKeyFile"           "eq" "/etc/ssl/private/journal-upload.pem" "hash"
        check_file_value    "is" "/etc/systemd/journal-upload.conf" "ServerCertificateFile"   "eq" "/etc/ssl/certs/journal-upload.pem"   "hash"
        check_file_value    "is" "/etc/systemd/journal-upload.conf" "TrustedCertificateFile"  "eq" "/etc/ssl/ca/trusted.pem"             "hash"
        check_file_value    "is" "/etc/systemd/journald.conf"       "Compress"                "eq" "yes"                                 "hash"
        check_file_value    "is" "/etc/systemd/journald.conf"       "Storage"                 "eq" "persistent"                          "hash"
        check_file_value    "is" "/etc/systemd/journald.conf"       "ForwardToSyslog"         "eq" "yes"                                 "hash"
        check_file_value    "is" "/etc/systemd/journald.conf"       "SystemMaxUse"            "eq" "1G"                                  "hash"
        check_file_value    "is" "/etc/systemd/journald.conf"       "SystemKeepFree"          "eq" "500M"                                "hash"
        check_file_value    "is" "/etc/systemd/journald.conf"       "RuntimeMaxUse"           "eq" "200M"                                "hash"
        check_file_value    "is" "/etc/systemd/journald.conf"       "RuntimeKeepFree"         "eq" "50M"                                 "hash"
        check_file_value    "is" "/etc/systemd/journald.conf"       "MaxFileSec"              "eq" "1month"                              "hash"
        check_linux_service "systemd-journal-upload.service"        "on"
        check_linux_service "systemd-journal-remote.socket"         "off"
        check_linux_service "systemd-journald.service"              "on"
        conf_file="/usr/lib/tmpfiles.d/systemd.conf"
        if [ -f "/usr/lib/tmpfiles.d/systemd.conf" ]; then
          conf_file="/usr/lib/tmpfiles.d/systemd.conf"
        else
          if [ -f "/etc/tmpfiles.d/systemd.conf" ]; then
            conf_file="/etc/tmpfiles.d/systemd.conf"
          fi
        fi
        if [ -f "${conf_file}" ]; then
          check_file_perms "${conf_file}"       "0640" "root" "root"
          check_file_value "is" "${conf_file}" "d /var/lib/private"    "space" "root root -" "hash"
          check_file_value "is" "${conf_file}" "d /var/log/private"    "space" "root root -" "hash"
          check_file_value "is" "${conf_file}" "d /var/cache/private"  "space" "root root -" "hash"
        fi
      fi
      conf_file="/etc/rsyslog.conf"
      if [ ! -f "${conf_file}" ]; then
        if [ "${install_rsyslog}" = "yes" ]; then
          check_linux_service "syslog"  "off"
          check_linux_package "install" "rsyslog"
          check_linux_service "rsyslog" "on"
        fi
      fi 
      if [ -f "/etc/rsyslog.d/60-rsyslog.conf" ]; then
        conf_file="/etc/rsyslog.d/60-rsyslog.conf"
        check_file_value  "is" "${conf_file}" "auth,authpriv.*"         "tab" "/var/log/secure"         "hash"
        check_file_value  "is" "${conf_file}" "mail.*"                  "tab" "/var/log/mail"           "hash"
        check_file_value  "is" "${conf_file}" "cron.*"                  "tab" "/var/log/cron"           "hash"
        check_file_value  "is" "${conf_file}" "*.=warning;*.=err"       "tab" "/var/log/warn"           "hash"
        check_file_value  "is" "${conf_file}" "*.crit"                  "tab" "/var/log/warn"           "hash"
        check_file_value  "is" "${conf_file}" "*.*;mail.none;news.none" "tab" "/var/log/messages"       "hash"
        check_file_value  "is" "${conf_file}" "local0,local1.*"         "tab" "/var/log/localmessages"  "hash"
        check_file_value  "is" "${conf_file}" "local2,local3.*"         "tab" "/var/log/localmessages"  "hash"
        check_file_value  "is" "${conf_file}" "local4,local5.*"         "tab" "/var/log/localmessages"  "hash"
        check_file_value  "is" "${conf_file}" "local6,local1.*"         "tab" "/var/log/localmessages"  "hash"
        conf_file="/etc/rsyslog.d/50-default.conf"
        check_file_value  "is" "${conf_file}" "auth,authpriv.*"         "tab" "/var/log/auth.log"       "hash"
        check_file_value  "is" "${conf_file}" "*.*;auth,authpriv.*"     "tab" "/var/log/syslog"         "hash"
        check_file_value  "is" "${conf_file}" "kern.*"                  "tab" "/var/log/kern.log"       "hash"
        check_file_value  "is" "${conf_file}" "mail.*"                  "tab" "/var/log/mail"           "hash"
      else
        if [ "${os_vendor}" = "CentOS" ] || [ "${os_vendor}" = "Red" ] || [ "${os_vendor}" = "SuSE" ] || [ "${os_vendor}" = "Amazon" ]; then
          if [ "${os_version}" -lt 4 ]; then
            check_file_value   "is" "${conf_file}" "*.emerg"                 "tab" ":omusrmsg:*"         "hash"
            check_file_value   "is" "${conf_file}" "mail.*"                  "tab" "/var/log/mail"       "hash"
            check_file_value   "is" "${conf_file}" "cron.*"                  "tab" "/var/log/cron"       "hash"
            check_file_value   "is" "${conf_file}" "*.crit"                  "tab" "/var/log/warn"       "hash"
            check_file_value   "is" "${conf_file}" "kern.*"                  "tab" "/var/log/kern.log"   "hash"
            check_file_value   "is" "${conf_file}" "daemon.*"                "tab" "/var/log/daemon.log" "hash"
            check_file_value   "is" "${conf_file}" "syslog.*"                "tab" "/var/log/syslog"     "hash"
            check_file_value   "is" "${conf_file}" "auth,user.*"             "tab" "/var/log/auth.log"   "hash"
            check_file_value   "is" "${conf_file}" "auth,authpriv.*"         "tab" "/var/log/secure"     "hash"
            check_file_value   "is" "${conf_file}" "*.=warning;*.=err"       "tab" "/var/log/warn"       "hash"
            check_file_value   "is" "${conf_file}" "*.*;mail.none;news.none" "tab" "/var/log/messages"   "hash"
            check_file_value   "is" "${conf_file}" "lpr,news,uucp,local0,local1,local2,local3,local4,local5,local6.*" "tab" "/var/log/localmessages" "hash"
            funct_file_perms   "${conf_file}"      "0600" "root" "root"
            if [ "${audit_mode}" != 2 ]; then
              command="grep -v '#' \"${check_file}\" | grep \"*.* @@\" | grep -v localhost | grep -c \"[A-Z]|[a-z]\""
              command_message "${command}"
              remote_check=$( eval "${command}" )
              if [ "${remote_check}" != "1" ]; then
                if [ "${audit_mode}" = 1 ] || [ "${audit_mode}" = 0 ]; then
                  increment_insecure "Rsyslog is not sending messages to a remote server"
                  verbose_message    "Add a server entry to ${check_file}, eg:" "fix"
                  verbose_message    "*.* @@loghost.example.com" "fix"
                fi
              else
                increment_secure "Rsyslog is sending messages to a remote server"
              fi
            fi
          fi
        fi
      fi
      conf_file="/etc/rsyslog.conf"
      if [ -f "${conf_file}" ]; then
        command="grep -E \"imtcp|imudp\" < \"${conf_file}\" | grep -cv \"^#\" | sed \"s/ //g\""
        command_message "${command}"
        server_check=$( eval "${command}" )
        if [ "${serial_check}" = "0" ]; then
          increment_secure    "Rsyslog is not running in server mode"
        else
          increment_insecure  "Rsyslog is running in server mode"
        fi
        check_file_value "is" "${conf_file}" "\$FileCreateMode" "space" "0640" "hash"
      fi
    fi
  fi
}
