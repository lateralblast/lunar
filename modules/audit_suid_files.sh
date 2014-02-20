# audit_suid_files
#
# The owner of a file can set the file's permissions to run with the owner's or
# group's permissions, even if the user running the program is not the owner or
# a member of the group. The most common reason for a SUID/SGID program is to
# enable users to perform functions (such as changing their password) that
# require root privileges.
# There are valid reasons for SUID/SGID programs, but it is important to
# identify and review such programs to ensure they are legitimate.
#.

audit_suid_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Set UID/GID Files"
    if [ "$audit_mode" = 1 ]; then
      echo "Checking:  For files with SUID/SGID set [This might take a while]"
      for check_file in `find / \( -fstype nfs -o -fstype cachefs \
        -o -fstype autofs -o -fstype ctfs -o -fstype mntfs \
        -o -fstype objfs -o -fstype proc \) -prune \
        -o -type f \( -perm -4000 -o -perm -2000 \) -print`; do
        echo "Warning:   File $check_file is SUID/SGID"
        file_type=`file $check_file |awk '{print $5}'`
        if [ "$file_type" != "script" ]; then
          elfsign_check=`elfsign verify -e $check_file 2>&1`
          echo "Result:    $elfsign_check"
        else
          echo "Result:    Shell script"
        fi
      done
    fi
  fi
}
