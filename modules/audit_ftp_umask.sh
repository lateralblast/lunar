#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ftp_umask
#
# Check FTP umask
#
# Refer to Section(s) 2.12.10 Page(s) 214-5 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 7.4     Page(s) 65-6  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 7.7     Page(s) 106-7 CIS Solaris 10 Benchmark v5.1.0
#.

audit_ftp_umask () {
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "AIX" ]; then
    verbose_message "Default umask for FTP Users" "check"
    if [ "${os_name}" = "AIX" ]; then
      check_file_value "is" "/etc/inetd.conf" "/usr/sbin/ftpd space" "ftpd -l -u077" "hash"
    fi
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ]; then
        check_file_value "is" "/etc/ftpd/ftpaccess" "defumask" "space" "077" "hash"
      fi
      if [ "${os_version}" = "11" ]; then
        check_file_value "is" "/etc/proftpd.conf" "Umask" "space" "027" "hash"
      fi
    fi
  fi
}
