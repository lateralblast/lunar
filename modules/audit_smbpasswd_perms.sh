#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_smbpasswd_perms
#
# Check SMB Password sttings
#
# Refer to Section(s) 11.4-5 Page(s) 144-5 CIS Solaris 10 Benchmark v1.1.0
#.

audit_smbpasswd_perms () {
  print_function "audit_smbpasswd_perms"
  if [ "${os_name}" = "SunOS" ]; then
    verbose_message  "SMB Password File"          "check"
    check_file_perms "/etc/sfw/private/smbpasswd" "0600" "root" "root"
  fi
}
