# audit_mount_noexec
#
# The noexec mount option specifies that the filesystem cannot contain
# executable binaries.
# Since the /tmp filesystem is only intended for temporary file storage, set
# this option to ensure that users cannot run executable binaries from /tmp.
#
# Refer to Section(s) 1.1.4 Page(s) 14-5 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.1.4 Page(s) 17-8 CIS Red Hat Linux 5 Benchmark v2.1.0
#.

audit_mount_noexec () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "No-exec on /tmp"
    check_file="/etc/fstab"
    if [ -e "$check_file" ]; then
      funct_verbose_message "Temp File Systems mounted with noexec"
      if [ "$audit_mode" != "2" ]; then
        nodev_check=`cat $check_file |grep -v "^#" |grep "tmpfs" |grep -v noexec |head -1 |wc -l`
        total=`expr $total + 1`
        if [ "$nodev_check" = 1 ]; then
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score - 1`
            echo "Warning:   Found tmpfs filesystems that should be mounted noexec [$score]"
            funct_verbose_message "" fix
            funct_verbose_message "cat $check_file | awk '( $3 ~ /^tmpfs$/ ) { $4 = $4 \",noexec\" }; { printf \"%-26s %-22s %-8s %-16s %-1s %-1s\n\",$1,$2,$3,$4,$5,$6 }' > $temp_file" fix
            funct_verbose_message "cat $temp_file > $check_file" fix
            funct_verbose_message "rm $temp_file" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   Setting noexec on tmpfs"
            funct_backup_file $check_file
            cat $check_file | awk '( $3 ~ /^tmpfs$/ ) { $4 = $4 ",noexec" }; { printf "%-26s %-22s %-8s %-16s %-1s %-1s\n",$1,$2,$3,$4,$5,$6 }' > $temp_file
            cat $temp_file > $check_file
            rm $temp_file
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score + 1`
            echo "Secure:    No filesystem that should be mounted with noexec [$score]"
          fi
          if [ "$audit_mode" = 2 ]; then
            funct_restore_file $check_file $restore_dir
          fi
        fi
      fi
      funct_check_perms $check_file 0644 root root
    fi
  fi
}
