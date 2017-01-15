# audit_sticky_bit
#
# When the so-called sticky bit (set with chmod +t) is set on a directory,
# then only the owner of a file may remove that file from the directory
# (as opposed to the usual behavior where anybody with write access to that
# directory may remove the file).
# Setting the sticky bit prevents users from overwriting each others files,
# whether accidentally or maliciously, and is generally appropriate for most
# world-writable directories (e.g. /tmp). However, consult appropriate vendor
# documentation before blindly applying the sticky bit to any world writable
# directories found in order to avoid breaking any application dependencies
# on a given directory.
#
# Refer to Section(s) 1.17   Page(s) 26    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.1.21 Page(s) 46    CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 1.1.17 Page(s) 28    CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.1.17 Page(s) 27    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.17   Page(s) 26    CIS SLES 11 Benchmark v1.2.0
# Refer to Section(s) 6.3    Page(s) 21-22 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 5.3    Page(s) 77-8  CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 1.1.18 Page(s) 42    CIS Amazon Linux Benchmark v2.0.0
#.

audit_sticky_bit () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    if [ "$do_fs" = 1 ]; then
      funct_verbose_message "World Writable Directories and Sticky Bits"
      total=`expr $total + 1`
      if [ "$os_version" = "10" ]; then
        if [ "$audit_mode" != 2 ]; then
          echo "Checking:  Sticky bits set on world writable directories [This may take a while]"
        fi
        log_file="$work_dir/sticky_bits"
        for check_dir in `find / \( -fstype nfs -o -fstype cachefs \
          -o -fstype autofs -o -fstype ctfs \
          -o -fstype mntfs -o -fstype objfs \
          -o -fstype proc \) -prune -o -type d \
          \( -perm -0002 -a -perm -1000 \) -print`; do
          if [ "$audit_mode" = 1 ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   Sticky bit not set on $check_dir [$insecure Warnings]"
            funct_verbose_message "" fix
            funct_verbose_message "chmod +t $check_dir" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   Sticky bit on $check_dir"
            chmod +t $check_dir
            echo "$check_dir" >> $log_file
          fi
        done
        if [ "$audit_mode" = 2 ]; then
          restore_file="$restore_dir/sticky_bits"
          if [ -f "$restore_file" ]; then
            for check_dir in `cat $restore_file`; do
              if [ -d "$check_dir" ]; then
                echo "Restoring:  Removing sticky bit from $check_dir"
                chmod -t $check_dir
              fi
            done
          fi
        fi
      fi
    fi
  fi
}
