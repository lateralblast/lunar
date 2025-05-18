#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_root_access
#
# Check root access 
#
# Refer to Section(s) 7.5     Page(s) 105-6 CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 5.4.2.4 Page(s) 700-1 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_root_access () {
  print_module "audit_root_access"
  if [ "${os_name}" = "Linux" ]; then
    verbose_message "Root account access" "check"
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    access_test=$( passwd -S root | awk '{ print $2}' | grep -cE "L"  )
    if [ "${access_test}" = "0" ]; then
      increment_insecure "Root account is not locked"
    else
      increment_secure   "Root account is locked"
    fi
  fi
}
