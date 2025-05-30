#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_mount_nodev
#
# Check nodev on mounts
#
# Refer to Section(s) 1.1.2,4,10,11,14,16 Page(s) 15-25         CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.1.2,4,10,11,14,16 Page(s) 16-26         CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.1.2,4,10,11,14,16 Page(s) 16-26         CIS RHEL 6 Benchmark v1.0.0
# Refer to Section(s) 1.1.3,8,14,15,18    Page(s) 33,39,40,43   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 1.1.3,8,14,15,18    Page(s) 27,31,37-8,41 CIS Ubuntu LTS 16.04 Benchmark v1.0.0
# Refer to Section(s) 1.1.2.[1-7].2       Page(s) 80-1,89-90,
#                                                 99-100,107-8
#                                                 123-4,132-3   CIS Ubuntu LTS 24.04 Benchmark v1.0.0
# Refer to Section(s) 2.2,4,10,11,14,16   Page(s) 15-25         CIS SLES 11 Benchmark v1.2.0
# Refer to Section(s) 1.1.8,14,17         Page(s) 32,38-9       CIS Amazon Linux Benchmark v2.0.0
#.

audit_mount_nodev () {
  print_function "audit_mount_nodev"
  if [ "${os_name}" = "Linux" ]; then
    check_file="/etc/fstab"
    if [ -e "${check_file}" ]; then
      verbose_message "File Systems mounted with nodev" "check"
      if [ "${audit_mode}" != "2" ]; then
        nodev_check=$( grep -v "^#" "${check_file}" | grep -E "ext2|ext3|swap|tmpfs" | grep -v '/ ' | grep -cv '/boot' | sed "s/ //g" )
        if [ "$nodev_check" = 1 ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure  "Found filesystems that should be mounted nodev"
            verbose_message     "cat ${check_file} | awk '( \$3 ~ /^ext[2,3,4]|tmpfs$/ && \$2 != \"/\" ) { \$4 = \$4 \",nodev\" }; { printf \"%-26s %-22s %-8s %-16s %-1s %-1s\n\",\$1,\$2,\$3,\$4,\$5,\$6 }' > ${temp_file}" "fix"
            verbose_message     "cat ${temp_file} > ${check_file}" "fix"
            verbose_message     "rm ${temp_file}" "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            verbose_message     "Setting:   Setting nodev on filesystems"
            backup_file         "${check_file}"
            awk '( $3 ~ /^ext[2,3,4]|tmpf$/ && $2 != "/" ) { $4 = $4 ",nodev" }; { printf "%-26s %-22s %-8s %-16s %-1s %-1s\n",$1,$2,$3,$4,$5,$6 }' < "${check_file}" > "${temp_file}"
            cat "${temp_file}" > "${check_file}"
            if [ -f "${temp_file}" ]; then
              rm "${temp_file}"
            fi
          fi
        else
          if [ "${audit_mode}" = 1 ]; then
            increment_secure "No filesystem that should be mounted with nodev"
          fi
          if [ "${audit_mode}" = 2 ]; then
            restore_file  "${check_file}" "${restore_dir}"
          fi
        fi
      fi
      check_file_perms    "${check_file}" "0644" "root" "root"
    fi
  fi
}
