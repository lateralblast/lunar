#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_remote_shell
#
# Turn off remote shell services
#
# Refer to Section(s) 1.2.7,9 Page(s) 31,33 CIS AIX Benchmark v1.1.0
#.

audit_remote_shell () {
  print_function "audit_remote_shell"
  string="Remote Shell"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "AIX" ] || [ "${os_name}" = "Linux" ]; then
    if [ "${os_name}" = "AIX" ]; then
      check_chsec "/etc/security/user" "root" "rlogin" "false"
      for user_name in daemon bin sys adm uucp nobody lpd; do
        check_chuser "login" "false" "rlogin" "false" "${user_name}"
      done
    fi
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
        for service_name in "svc:/network/shell:kshell" \
          "svc:/network/login:eklogin" "svc:/network/login:klogin" \
          "svc:/network/rpc/rex:default" "svc:/network/rexec:default" \
          "svc:/network/shell:default" "svc:/network/login:rlogin" \
          "svc:/network/telnet:default"; do
          check_sunos_service "${service_name}" "disabled"
        done
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      for service_name in telnet login rlogin rsh shell; do
        check_linux_service "${service_name}" "off"
      done
    fi
  else
    na_message "${string}"
  fi
}
