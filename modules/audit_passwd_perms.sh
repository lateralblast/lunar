#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_passwd_perms
#
# Refer to Section(s) 9.1.2-9  Page(s) 153-9   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.1.2-9  Page(s) 177-83  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.2-9  Page(s) 157-62  CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.1.2-9  Page(s) 261-8   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 12.2-7   Page(s) 146-50  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.1.2-9  Page(s) 239-46  CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 6.1      Page(s) 21      CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.11.1-3 Page(s) 192-4   CIS AIX Benchmark v1.1.0
# Refer to Section(s) 6.1.2-9  Page(s) 253-60  CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 7.1.1-8  Page(s) 934-49  CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_passwd_perms () {
  if [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ] || [ "${os_name}" = "AIX" ]; then
    verbose_message "Group and Password File Permissions" "check"
    if [ "${os_name}" = "AIX" ]; then
      for check_file in /etc/passwd /etc/group; do
        check_file_perms ${check_file} 0644 root security
      done
      check_dir="/etc/security"
      check_file_perms ${check_dir} 0750 root security
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_file_perms "/etc/passwd"        "0644" "root" "root"
      check_file_perms "/etc/group"         "0644" "root" "root"
      check_file_perms "/etc/shadow"        "0600" "root" "root"
      check_file_perms "/etc/gshadow"       "0600" "root" "root"
      check_file_perms "/etc/group-"        "0600" "root" "root"
      check_file_perms "/etc/passwd-"       "0600" "root" "root"
      check_file_perms "/etc/shadow-"       "0600" "root" "root"
      check_file_perms "/etc/gshadow-"      "0600" "root" "root"
    fi
    if [ "${os_name}" = "FreeBSD" ]; then
      check_file_perms "/etc/passwd"        "0644" "root" "${wheel_group}"
      check_file_perms "/etc/group"         "0644" "root" "${wheel_group}"
      check_file_perms "/etc/pwd.db_file"   "0644" "root" "${wheel_group}"
      check_file_perms "/etc/master.passwd" "0600" "root" "${wheel_group}"
      check_file_perms "/etc/spwd.db"       "0600" "root" "${wheel_group}"
    fi
  fi
}
