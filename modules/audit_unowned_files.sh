# audit_unowned_files
#
# Sometimes when administrators delete users from the password file they
# neglect to remove all files owned by those users from the system.
# A new user who is assigned the deleted user's user ID or group ID may then
# end up "owning" these files, and thus have more access on the system than
# was intended.
#
# Refer to Section(s) 9.1.11-2 Page(s) 160-1 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.1.11-2 Page(s) 184-6 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.1.11-2 Page(s) 163-4 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.1.11-2 Page(s) 270-1 CIS Red Hat Linux 7 Benchmark v2.1.0
# Refer to Section(s) 12.9-10  Page(s) 151-2 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.7      Page(s) 23    CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.16.2   Page(s) 232-3 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.24     Page(s) 89-90 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.24     Page(s) 135-6 CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.1.11-2 Page(s) 248-9 CIS Amazon Linux Benchmark v1.0.0
#.

audit_unowned_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "Unowned Files and Directories"
    if [ "$audit_mode" = 1 ]; then
      echo "Checking:  For Un-owned files and directories [This might take a while]"
      if [ "$os_name" = "SunOS" ]; then
        find_command="find / \( -fstype nfs -o -fstype cachefs \
        -o -fstype autofs -o -fstype ctfs -o -fstype mntfs \
        -o -fstype objfs -o -fstype proc \) -prune \
        -o \( -nouser -o -nogroup \) -print"
      fi
      if [ "$os_name" = "AIX" ]; then
        find_command="find / \( -fstype jfs -o -fstype jfs2 \) \
        \( -type d -o -type f \) \( -nouser -o -nogroup \) -ls"
      fi
      if [ "$os_name" = "Linux" ]; then
        find_command="df --local -P | awk {'if (NR!=1) print $6'} \
        | xargs -I '{}' find '{}' -xdev -nouser -ls"
      fi
      for check_file in `$find_command`; do
        total=`expr $total + 1`
        insecure=`expr $insecure + 1`
        echo "Warning:   File $check_file is unowned [$insecure Warnings]"
      done
    fi
  fi
}
