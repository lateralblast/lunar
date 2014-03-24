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
# Refer to Section 9.1.10 Page(s) 159-160 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_writable_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
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
        for check_file in `find / \( -fstype nfs -o -fstype cachefs \
          -o -fstype autofs -o -fstype ctfs -o -fstype mntfs \
          -o -fstype objfs -o -fstype proc \) -prune \
          -o -type f -perm -0002 -print`; do
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score - 1`
            echo "Warning:   File $check_file is world writable [$score]"
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
