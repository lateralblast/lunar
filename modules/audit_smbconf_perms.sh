#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_smbconf_perms
#
# Check SMB config permissions
#
# Refer to Section(s) 11.2-3 Page(s) 143-4 CIS Solaris 10 Benchmark v1.1.0
#.

audit_smbconf_perms () {
  print_module "audit_smbconf_perms"
  if [ "${os_name}" = "SunOS" ]; then
    verbose_message  "SMB Config Permissions" "check"
    check_file_perms "/etc/samba/smb.conf"    "0644" "root" "root"
  fi
}
