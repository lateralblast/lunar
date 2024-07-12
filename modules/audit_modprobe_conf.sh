#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_modprobe_conf
#
# Check modprobe on filesystems
#
# Refer to Section(s) 1.18-24,5.6.1-4    Page(s) 26-verbose_message ",114-6   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.18-24,4.6.1-4    Page(s) 27-32,90-2    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 1.1.1.1-8,3.5.1-4  Page(s) 17-25,149-152 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 1.1.1.1-8,3.5.1-4  Page(s) 16-24,144-7   CIS Ubuntu LTS 16.04 Benchmark v1.0.0
# Refer to Section(s) 2.18-24,7.5.1-4    Page(s) 26-verbose_message ",80-3    CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.1.18-24,4.6.1-2  Page(s) 28-33,98-100  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.1.1.1-18,3.5.1-4 Page(s) 16-24,135-8   CIS Amazon Linux Benchmark v2.0.0
#.

audit_modprobe_conf () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Modprobe Configuration" "check"
    check_append_file "/etc/modprobe.conf" "install tipc /bin/true"     "hash"
    check_append_file "/etc/modprobe.conf" "install rds /bin/true"      "hash"
    check_append_file "/etc/modprobe.conf" "install sctp /bin/true"     "hash"
    check_append_file "/etc/modprobe.conf" "install dccp /bin/true"     "hash"
    check_append_file "/etc/modprobe.conf" "install udf /bin/true"      "hash"
    check_append_file "/etc/modprobe.conf" "install squashfs /bin/true" "hash"
    check_append_file "/etc/modprobe.conf" "install hfs /bin/true"      "hash"
    check_append_file "/etc/modprobe.conf" "install hfsplus /bin/true"  "hash"
    check_append_file "/etc/modprobe.conf" "install jffs2 /bin/true"    "hash"
    check_append_file "/etc/modprobe.conf" "install freevxfs /bin/true" "hash"
    check_append_file "/etc/modprobe.conf" "install cramfs /bin/true"   "hash"
    check_append_file "/etc/modprobe.conf" "install vfat /bin/true"     "hash"
  fi
}
