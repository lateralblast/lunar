# audit_suid_files
#
# Refer to Section(s) 9.1.13-4 Page(s) 161-2 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.1.13-4 Page(s) 186-7 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.1.13-4 Page(s) 164-5 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.1.12-4 Page(s) 272-4 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 12.11-12 Page(s) 152-3 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.5      Page(s) 22    CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.16.1   Page(s) 231-2 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.23     Page(s) 88-9  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.1.12-4 Page(s) 250-2 CIS Amazon Linux Benchmark v1.0.0
# Refer to Section(s) 6.1.13-4 Page(s) 264-5 CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_suid_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Set UID/GID Files"
    log_file="setuidfiles.log"
    if [ "$audit_mode" = 0 ]; then
      log_file="$work_dir/$log_file"
    fi
    if [ "$audit_mode" = 1 ]; then
      if [ "$os_name" = "Linux" ]; then
        for file_system in $( df --local -P | awk {'if (NR!=1) print $6'} 2> /dev/null ); do
          for check_file in $( find $file_system -xdev -type f -perm -4000 -print 2> /dev/null ); do
            increment_insecure "File $check_file is SUID/SGID"
            if [ "$ansible" = 1 ]; then
              echo ""
              echo "- name: Checking write permissions for $check_file"
              echo "  file:"
              echo "    path: $check_file"
              echo "    mode: o-S"
              echo ""
            fi
            if [ "$audit_mode" = 1 ]; then
              increment_insecure "File $check_file is world writable"
              verbose_message "" fix
              verbose_message "chmod o-S $check_file" fix
              verbose_message "" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              echo "$check_file" >> $log_file
              verbose_message "Setting:   File $check_file to be non world writable"
              chmod o-S $check_file
            fi
          done
        done
      else
        if [ "$os_name" = "SunOS" ]; then
          find_command="find / \( -fstype nfs -o -fstype cachefs \
          -o -fstype autofs -o -fstype ctfs -o -fstype mntfs \
          -o -fstype objfs -o -fstype proc \) -prune \
          -o -type f \( -perm -4000 -o -perm -2000 \) -print"
        fi
        if [ "$os_name" = "AIX" ]; then
          find_command="find / \( -fstype jfs -o -fstype jfs2 \) \
          \( -perm -04000 -o -perm -02000 \) -typ e f -ls"
        fi
        for check_file in $( $find_command ); do
          increment_insecure "File $check_file is SUID/SGID"
          if [ "$ansible" = 1 ]; then
            echo ""
            echo "- name: Checking write permissions for $check_file"
            echo "  file:"
            echo "    path: $check_file"
            echo "    mode: o-S"
            echo ""
          fi
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "File $check_file is world writable"
            verbose_message "" fix
            verbose_message "chmod o-S $check_file" fix
            verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "$check_file" >> $log_file
            verbose_message "Setting:   File $check_file to be non world writable"
            chmod o-S $check_file
          fi
        done
      fi
    fi
  fi
}
