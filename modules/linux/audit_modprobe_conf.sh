#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_modprobe_conf
#
# Check modprobe on filesystems
#
# Refer to Section(s) 1.18-24,5.6.1-4     Page(s) 26-30,114-6   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.18-24,4.6.1-4     Page(s) 27-32,90-2    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 1.1.1.1-8,3.5.1-4   Page(s) 17-25,149-152 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 1.1.1.1-8,3.5.1-4   Page(s) 16-24,144-7   CIS Ubuntu LTS 16.04 Benchmark v1.0.0
# Refer to Section(s) 1.1.1.1-10,3.2.1-4  Page(s) 23-73,365-84  CIS Ubuntu LTS 24.04 Benchmark v1.0.0
# Refer to Section(s) 2.18-24,7.5.1-4     Page(s) 26-30,80-3    CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.1.18-24,4.6.1-2   Page(s) 28-33,98-100  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.1.1.1-18,3.5.1-4  Page(s) 16-24,135-8   CIS Amazon Linux Benchmark v2.0.0
#.

audit_modprobe_conf () {
  print_function "audit_modprobe_conf"
  string="Modprobe Configuration"
  check_message  "${string}"
  if [ "${os_name}" = "Linux" ]; then
    for module in cramfs freevxfs hfs hfsplus jffs2 overlayfs squashfs udf usb-storage afs ceph \
      cifs ext fat fscache fuse gfs2 nfs_common nfsd smbfs_common tipc rds sctp dccp vfat; do
      check_append_file "/etc/modprobe.conf" "install ${module} /bin/false" "hash"
    done
  else
    na_message "${string}"
  fi
}
