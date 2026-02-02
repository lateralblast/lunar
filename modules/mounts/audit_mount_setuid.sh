#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_mount_setuid
#
# Check Set-UID on mounts
#
# Refer to Section(s) 1.1.3,13,15   Page(s) 14-25               CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.1.3,13,15   Page(s) 17-27               CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.1.4,9,16,19 Page(s) 29,34,41,44         CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 1.1.4,9,16,19 Page(s) 28,33,40,43         CIS Ubuntu LTS 16.04 Benchmark v1.0.0
# Refer to Section(s) 1.1.2.[1-7].3 Page(s) 82-3,91-2,101-2,
#                                           109-10,116-7,125-6
#                                           134-5               CIS Ubuntu LTS 24.04 Benchmark v1.0.0
# Refer to Section(s) 2.3,13,15     Page(s) 16-25               CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.1           Page(s) 21                  CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 5.2           Page(s) 76-7                CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 1.1.4,9,16    Page(s) 28,33,40            CIS Amazon Linux Benchmark v2.0.0
#.

audit_mount_setuid () {
  print_function "audit_mount_setuid"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "FreeBSD" ]; then
    verbose_message "Set-UID on Mounted Devices" "check"
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ]; then
        check_file="/etc/rmmount.conf"
        if [ -f "${check_file}" ]; then
          command="grep -v \"^#\" \"${check_file}\" | grep \"\\-o nosuid\""
          command_message "${command}"
          nosuid_check=$( eval "${command}" )
          log_file="${work_dir}/${check_file}"
          if [ -n "$nosuid_check" ]; then
            if [ "${audit_mode}" = 1 ]; then
              increment_insecure "Set-UID not restricted on user mounted devices"
            fi
            if [ "${audit_mode}" = 0 ]; then
              verbose_message   "Set-UID restricted on user mounted devices" "check"
              backup_file       "${check_file}"
              check_append_file "${check_file}" "mount * hsfs udfs ufs -o nosuid" "hash"
            fi
          else
            if [ "${audit_mode}" = 1 ]; then
              increment_secure "Set-UID not restricted on user mounted devices"
            fi
            if [ "${audit_mode}" = 2 ]; then
              restore_file "${check_file}" "${restore_dir}"
            fi
          fi
        fi
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_file="/etc/fstab"
      if [ -e "${check_file}" ]; then
        verbose_message "File Systems mounted with nodev" "check"
        if [ "${audit_mode}" != "2" ]; then
          command="grep -v \"^#\" \"${check_file}\" | grep -E \"ext2|ext3|ext4|swap|tmpfs\" | grep -v '/ ' | grep -cv '/boot' | sed \"s/ //g\""
          command_message "${command}"
          nodev_check=$( eval "${command}" )
          if [ ! "$nodev_check" = "0" ]; then
            if [ "${audit_mode}" = 1 ]; then
              increment_insecure  "Found filesystems that should be mounted nodev"
              verbose_message     "cat ${check_file} | awk '( \$3 ~ /^ext[2,3,4]|tmpfs$/ && \$2 != \"/\" ) { \$4 = \$4 \",nosuid\" }; { printf \"%-26s %-22s %-8s %-16s %-1s %-1s\\n\",\$1,\$2,\$3,\$4,\$5,\$6 }' > ${temp_file}" "fix"
              verbose_message     "cat ${temp_file} > ${check_file}" "fix"
              verbose_message     "rm ${temp_file}" "fix"
            fi
            if [ "${audit_mode}" = 0 ]; then
              verbose_message "Setting nodev on filesystems" "set"
              backup_file     "${check_file}"
              command="awk '( \$3 ~ /^ext[2,3,4]|tmpfs$/ && \$2 != \"/\" ) { \$4 = \$4 \",nosuid\" }; { printf \"%-26s %-22s %-8s %-16s %-1s %-1s\\n\",\$1,\$2,\$3,\$4,\$5,\$6 }' < \"${check_file}\" > \"${temp_file}\""
              command_message "${command}"
              eval "${command}"
              command="cat \"${temp_file}\" > \"${check_file}\""
              command_message "${command}"
              eval "${command}"
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
  fi
}
