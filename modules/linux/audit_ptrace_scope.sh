#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ptrace_scope
#
# Refer to Section(s) 1.5.2 Page(s) 170-4 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_ptrace_scope () {
  print_function "audit_ptrace_scope"
  if [ "${os_name}" = "Linux" ]; then
    verbose_message "Ptrace scope is restricted" "check"
    if [ "${os_vendor}" = "Ubuntu" ]; then
      if [ "${os_version}" -ge 24 ]; then
        check_file_value "is" "/etc/sysctl.conf" "kernel.yama.ptrace_scope" "eq" "1" "hash"
      fi
    fi
  fi
}