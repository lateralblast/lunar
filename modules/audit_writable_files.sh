# audit_writable_files
#
# Refer to Section(s) 9.1.10   Page(s) 159-160 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.1.10   Page(s) 183-4   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.1.10   Page(s) 162-3   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.1.10   Page(s) 269     CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 12.8     Page(s) 150-1   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.1.10   Page(s) 247     CIS Amazon Linux Benchmark v1.0.0
# Refer to Section(s) 6.4      Page(s) 22      CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.16.3   Page(s) 233-4   CIS AIX Benchmark v1.1.0
# Refer to Section(s) 5.1,9.22 Page(s) 45,88   CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.22     Page(s) 134     CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.1.10   Page(s) 261     CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 5.1.3-4  Page(s) 110-1   CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_writable_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    if [ "$do_fs" = 1 ]; then
      verbose_message "World Writable Files"
      log_file="worldwritablefiles.log"
      if [ "$audit_mode" = 0 ]; then
        log_file="$work_dir/$log_file"
      fi
      if [ "$audit_mode" != 2 ]; then
        if [ "$os_name" = "Linux" ]; then
          for file_system in $( df --local -P | awk {'if (NR!=1) print $6'} 2> /dev/null ); do
            for check_file in $( find $file_system -xdev -type f -perm -0002 2> /dev/null ); do
              if [ "$ansible" = 1 ]; then
                echo ""
                echo "- name: Checking write permissions for $check_file"
                echo "  file:"
                echo "    path: $check_file"
                echo "    mode: o-w"
                echo ""
              fi
              if [ "$audit_mode" = 1 ]; then
                increment_insecure "File $check_file is world writable"
                verbose_message "" fix
                verbose_message "chmod o-w $check_file" fix
                verbose_message "" fix
              fi
              if [ "$audit_mode" = 0 ]; then
                echo "$check_file" >> $log_file
                verbose_message "Setting:   File $check_file to be non world writable"
                chmod o-w $check_file
              fi
            done
          done
        else
          if [ "$os_name" = "SunOS" ]; then
            find_command="find / \( -fstype nfs -o -fstype cachefs \
            -o -fstype autofs -o -fstype ctfs -o -fstype mntfs \
            -o -fstype objfs -o -fstype proc \) -prune \
            -o -type f -perm -0002 -print"
          fi
          if [ "$os_name" = "AIX" ]; then
            find_command="find / \( -fstype jfs -o -fstype jfs2 \) \
            \( -type d -o -type f \) -perm -o+w -ls"
          fi
          if [ "$os_name" = "FreeBSD" ]; then
            find_command="find / \( -fstype ufs -type file -perm -0002 \
            -a ! -perm -1000 \) -print"
          fi
          for check_file in $( $find_command ); do
            if [ "$ansible" = 1 ]; then
              echo ""
              echo "- name: Checking write permissions for $check_file"
              echo "  file:"
              echo "    path: $check_file"
              echo "    mode: o-w"
              echo ""
            fi
            if [ "$audit_mode" = 1 ]; then
              increment_insecure "File $check_file is world writable"
              verbose_message "" fix
              verbose_message "chmod o-w $check_file" fix
              verbose_message "" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              echo "$check_file" >> $log_file
              verbose_message "Setting:   File $check_file to be non world writable"
              chmod o-w $check_file
            fi
          done
        fi
      fi
      if [ "$audit_mode" = 2 ]; then
        restore_file="$restore_dir/$log_file"
        if [ -f "$restore_file" ]; then
          for check_file in $( cat $restore_file ); do
            if [ -f "$check_file" ]; then
              verbose_message "Restoring: File $check_file to previous permissions"
              chmod o+w $check_file
            fi
          done
        fi
      fi
    fi
  fi
}
