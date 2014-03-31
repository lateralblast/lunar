# audit_mount_nodev
#
# Check filesystems are mounted with nodev
#
# Prevents device files from being created on filesystems where they should
# not be created. This can stop possible vectors of attack and escalated
# privileges.
# Ignore / and /boot.
#
# Refer to Section 1.1.2,4,10,11,14,16 Page(s) 15-25 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section 1.1.2,4,10,11,14,16 Page(s) 16-26 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section 1.1.2,4,10,11,14,16 Page(s) 16-26 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

audit_mount_nodev () {
  if [ "$os_name" = "Linux" ]; then
    check_file="/etc/fstab"
    if [ -e "$check_file" ]; then
      funct_verbose_message "File Systems mounted with nodev"
      if [ "$audit_mode" != "2" ]; then
        nodev_check=`cat $check_file |grep -v "^#" |egrep "ext2|ext3|swap|tmpfs" |grep -v '/ ' |grep -v '/boot' |head -1 |wc -l`
        total=`expr $total + 1`
        if [ "$nodev_check" = 1 ]; then
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score - 1`
            echo "Warning:   Found filesystems that should be mounted nodev [$score]"
            funct_verbose_message "" fix
            funct_verbose_message "cat $check_file | awk '( $3 ~ /^ext[2,3,4]|tmpfs$/ && $2 != \"/\" ) { $4 = $4 \",nodev\" }; { printf \"%-26s %-22s %-8s %-16s %-1s %-1s\n\",$1,$2,$3,$4,$5,$6 }' > $temp_file" fix
            funct_verbose_message "cat $temp_file > $check_file" fix
            funct_verbose_message "rm $temp_file" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   Setting nodev on filesystems"
            funct_backup_file $check_file
            cat $check_file | awk '( $3 ~ /^ext[2,3,4]|tmpf$/ && $2 != "/" ) { $4 = $4 ",nodev" }; { printf "%-26s %-22s %-8s %-16s %-1s %-1s\n",$1,$2,$3,$4,$5,$6 }' > $temp_file
            cat $temp_file > $check_file
            rm $temp_file
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score + 1`
            echo "Secure:    No filesystem that should be mounted with nodev [$score]"
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
