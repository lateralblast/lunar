# audit_mount_setuid
#
# Refer to Section(s) 1.1.3,13,15   Page(s) 14-25       CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.1.3,13,15   Page(s) 17-27       CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.1.4,9,16,19 Page(s) 29,34,41,44 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 1.1.4,9,16,19 Page(s) 28,33,40,43 CIS Ubuntu LTS 16.04 Benchmark v1.0.0
# Refer to Section(s) 2.3,13,15     Page(s) 16-25       CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.1           Page(s) 21          CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 5.2           Page(s) 76-7        CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 1.1.4,9,16    Page(s) 28,33,40    CIS Amazon Linux Benchmark v2.0.0
#.

audit_mount_setuid () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    verbose_message "Set-UID on Mounted Devices"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        check_file="/etc/rmmount.conf"
        if [ -f "$check_file" ]; then
          nosuid_check=$( grep -v "^#" $check_file |grep "\-o nosuid" )
          log_file="$work_dir/$check_file"
          if [ $( expr "$nosuid_check" : "[A-z]" ) != 1 ]; then
            if [ "$audit_mode" = 1 ]; then
              increment_insecure "Set-UID not restricted on user mounted devices"
            fi
            if [ "$audit_mode" = 0 ]; then
              verbose_message "Setting:   Set-UID restricted on user mounted devices"
              backup_file $check_file
              check_append_file $check_file "mount * hsfs udfs ufs -o nosuid" hash
            fi
          else
            if [ "$audit_mode" = 1 ]; then
              increment_secure "Set-UID not restricted on user mounted devices"
            fi
            if [ "$audit_mode" = 2 ]; then
              restore_file $check_file $restore_dir
            fi
          fi
        fi
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      check_file="/etc/fstab"
      if [ -e "$check_file" ]; then
        verbose_message "File Systems mounted with nodev"
        if [ "$audit_mode" != "2" ]; then
          nodev_check=$( grep -v "^#" $check_file | egrep "ext2|ext3|ext4|swap|tmpfs" | grep -v '/ ' | grep -v '/boot' | head -1 | wc -l )
          if [ "$nodev_check" = 1 ]; then
            if [ "$audit_mode" = 1 ]; then
              increment_insecure "Found filesystems that should be mounted nodev"
              verbose_message "" fix
              verbose_message "cat $check_file | awk '( $3 ~ /^ext[2,3,4]|tmpfs$/ && $2 != \"/\" ) { $4 = $4 \",nosuid\" }; { printf \"%-26s %-22s %-8s %-16s %-1s %-1s\n\",$1,$2,$3,$4,$5,$6 }' > $temp_file" fix
              verbose_message "cat $temp_file > $check_file" fix
              verbose_message "rm $temp_file" fix
              verbose_message "" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              verbose_message "Setting:   Setting nodev on filesystems"
              backup_file $check_file
              cat $check_file | awk '( $3 ~ /^ext[2,3,4]|tmpfs$/ && $2 != "/" ) { $4 = $4 ",nosuid" }; { printf "%-26s %-22s %-8s %-16s %-1s %-1s\n",$1,$2,$3,$4,$5,$6 }' > $temp_file
              cat $temp_file > $check_file
              rm $temp_file
            fi
          else
            if [ "$audit_mode" = 1 ]; then
              increment_secure "No filesystem that should be mounted with nodev"
            fi
            if [ "$audit_mode" = 2 ]; then
              restore_file $check_file $restore_dir
            fi
          fi
        fi
        check_file_perms $check_file 0644 root root
      fi
    fi
  fi
}
