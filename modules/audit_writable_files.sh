# audit_writable_files
#
# Unix-based systems support variable settings to control access to files.
# World writable files are the least secure. See the chmod(2) man page for more
# information.
# Data in world-writable files can be modified and compromised by any user on
# the system. World writable files may also indicate an incorrectly written
# script or program that could potentially be the cause of a larger compromise
# to the system's integrity.
#
# Refer to Section(s) 9.1.10   Page(s) 159-160 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.1.10   Page(s) 183-4   CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.1.10   Page(s) 162-3   CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 12.8     Page(s) 150-1   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.1.10   Page(s) 247     CIS Amazon Linux Benchmark v1.0.0
# Refer to Section(s) 6.4      Page(s) 22      CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.16.3   Page(s) 233-4   CIS AIX Benchmark v1.1.0
# Refer to Section(s) 5.1,9.22 Page(s) 45,88   CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.22     Page(s) 134     CIS Solaris 10 Benchmark v1.1.0
#.

audit_writable_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    if [ "$do_fs" = 1 ]; then
      funct_verbose_message "World Writable Files"
      if [ "$audit_mode" != 2 ]; then
        echo "Checking:  For world writable files [This might take a while]"
      fi
      log_file="worldwritable.log"
      total=`expr $total + 1`
      if [ "$audit_mode" = 0 ]; then
        log_file="$work_dir/$log_file"
      fi
      if [ "$audit_mode" != 2 ]; then
        if [ "$os_name" = "SunOS" ]; then
          find_command="find / \( -fstype nfs -o -fstype cachefs \
          -o -fstype autofs -o -fstype ctfs -o -fstype mntfs \
          -o -fstype objfs -o -fstype proc \) -prune \
          -o -type f -perm -0002 -print"
        fi
        if [ "$os_name" = "Linux" ]; then
          find_command="df --local -P | awk {'if (NR!=1) print $6'} \
          | xargs -I '{}' find '{}' -xdev -type f -perm -0002"
        fi
        if [ "$os_name" = "AIX" ]; then
          find_command="find / \( -fstype jfs -o -fstype jfs2 \) \
          \( -type d -o -type f \) -perm -o+w -ls"
        fi
        if [ "$os_name" = "FreeBSD" ]; then
          find_command="find / \( -fstype ufs -type file -perm -0002 \
          -a ! -perm -1000 \) -print"
        fi
        for check_file in `$find_command`; do
          if [ "$audit_mode" = 1 ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   File $check_file is world writable [$insecure Warnings]"
            funct_verbose_message "" fix
            funct_verbose_message "chmod o-w $check_file" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "$check_file" >> $log_file
            echo "Setting:   File $check_file non world writable [$score]"
            chmod o-w $check_file
          fi
        done
      fi
      if [ "$audit_mode" = 2 ]; then
        restore_file="$restore_dir/$log_file"
        if [ -f "$restore_file" ]; then
          for check_file in `cat $restore_file`; do
            if [ -f "$check_file" ]; then
              echo "Restoring: File $check_file to previous permissions"
              chmod o+w $check_file
            fi
          done
        fi
      fi
    fi
  fi
}
