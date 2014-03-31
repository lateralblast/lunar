# audit_suid_files
#
# The owner of a file can set the file's permissions to run with the owner's or
# group's permissions, even if the user running the program is not the owner or
# a member of the group. The most common reason for a SUID/SGID program is to
# enable users to perform functions (such as changing their password) that
# require root privileges.
# There are valid reasons for SUID/SGID programs, but it is important to
# identify and review such programs to ensure they are legitimate.
#
# Refer to Section(s) 9.1.13-4 Page(s) 161-2 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.1.13-4 Page(s) 186-7 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.1.13-4 Page(s) 164-5 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.5 Page(s) 22 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.16.1 Page(s) 231-2 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.23 Page(s) 88-9 CIS Solaris 11.1 v1.0.0
#.

audit_suid_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "Set UID/GID Files"
    if [ "$audit_mode" = 1 ]; then
      echo "Checking:  For files with SUID/SGID set [This might take a while]"
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
      if [ "$os_name" = "Linux" ]; then
        find_command="df --local -P | awk {'if (NR!=1) print $6'} \
        | xargs -I '{}' find '{}' -xdev -type f -perm -4000 -print"
      fi
      for check_file in `$find_command`; do
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
