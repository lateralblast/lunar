#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_selinux
#
# Make sure SELinux is configured appropriately.
#
# Refer to Section(s) 1.4.1-5,1.5.1-2 Page(s) 36-40,41-2  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.4.1-5,1.5.1-2 Page(s) 41-45,46-7  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.4.1-5,1.5.1-2 Page(s) 39-42,43-4  CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 1.6.1.1-5       Page(s) 69-74       CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 1.6.1.1-3       Page(s) 64-7        CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 1.6.1.1-5       Page(s) 60-66       CIS Amazon Linux Benchmark v2.0.0
#.

audit_selinux () {
  print_function "audit_selinux"
  if [ "${os_name}" = "Linux" ]; then
    verbose_message  "SELinux" "check"
    check_file_value "is" "/etc/selinux/config" "SELINUX"     "eq" "enforcing" "hash"
    check_file_value "is" "/etc/selinux/config" "SELINUXTYPE" "eq" "targeted"  "hash"
    check_file_perms "/etc/selinux/config"      "0400" "root" "root"
    for check_file in /etc/grub.conf /boot/grub/grub.cfg; do
      if [ -e "${check_file}" ]; then
        check_file_perms "${check_file}".     "0400"      "root" "root"
        check_file_value "is" "${check_file}" "selinux"   "eq"   "1"    "hash"
        check_file_value "is" "${check_file}" "enforcing" "eq"   "1"    "hash"
      fi
    done
    check_linux_package "uninstall" "setroubleshoot"
    check_linux_package "uninstall" "mctrans"
  fi
}
